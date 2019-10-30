const isValidCoordinates = require("is-valid-coordinates");
const notifications = require("../notifications/notifications");

// import Event and User schemas
let Event = require("../models/event");
let User = require("../models/user");
let UserSettings = require("../models/userSettings");

// retrieve all data on an event by id in query string
let getEvent = async function(req, resp) {
  try {
    const eventId = req.query.id;
    if (!eventId) {
      return resp.status(400).send("no event id in query string");
    }

    let event = await Event.findById(eventId);
    if (!event) {
      return resp.status(404).send("Event not found");
    }
    resp.json(event);
  } catch (e) {
    console.log(`[error] ${e}`);
    return resp.status(500).send("Could not retrieve event");
  }
};

// create an event (from json request body)
let createEvent = async function(req, resp) {
  try {
    // creator from token
    const creator = req.authorization.id;

    // event details from req body
    const {
      name,
      description,
      latitude,
      longitude,
      startTime,
      endTime,
      public,
      invited
    } = req.body;

    // enforce types
    const lat = Number(latitude);
    const lon = Number(longitude);
    const start = Number(startTime);
    const end = Number(endTime);

    // validate inputs
    if (!name) {
      return resp.status(400).send("no event name provided");
    }
    if (!description) {
      return resp.status(400).send("no event description provided");
    }
    if (!lat || !lon) {
      return resp.status(400).send("no coordinates provided");
    }
    if (!start) {
      return resp.status(400).send("no start time provided");
    }
    if (!end) {
      return resp.status(400).send("no end time provided");
    }
    if (!isValidCoordinates(lon, lat)) {
      return resp.status(400).send("invalid coordinates");
    }
    if (end < Date.now()) {
      return resp.status(400).send("event end time cannot be before now");
    }

    // avoid null array
    if (!invited) {
      invited = [];
    }

    let newEvent = new Event({
      name: name,
      description: description,
      location: { type: "Point", coordinates: [lon, lat] },
      startTime: start,
      endTime: end,
      creator: creator,
      public: public,
      invited: invited
    });

    let event = await newEvent.save();

    let creatorUser = await User.findById(creator);
    creatorUser.createdEvents.push(event._id);
    await creatorUser.save();

    if (invited != null && invited.length != 0) {
      let userSettings = await UserSettings.find({
        _id: { $in: invited }
      });

      let invitedUsersTokens = [];
      for (let user of userSettings) {
        invitedUsersTokens.push(user.fcmToken);
      }

      let notification = {
        title: "New Event Invitation",
        body: `You have been invited to ${event.name} by ${event.creator}`
      };
      notifications.notify(notification, invitedUsersTokens);
    }

    let response = {
      message: "Event created successfully!",
      data: {
        eventId: event._id
      }
    };
    resp.json(response);
  } catch (e) {
    console.log(`[error] ${e}`);
    return resp.status(500).send("Failed to create event");
  }
};

// update an event if user is creator
let updateEvent = async function(req, resp) {
  try {
    let newEvent = req.body.event;
    if (!newEvent) {
      return resp.status(400).send("no event id specified");
    }
    let event = await Event.findByIdAndUpdate(newEvent._id, newEvent);
    resp.send(event);
  } catch (e) {
    console.log(`[error] ${e}`);
    return resp.status(500).send("Error updating event");
  }
};

// invite people to an event
let invitePeople = async function(req, resp) {
  const invited = req.body.invited;

  if (!invited) {
    invited = [];
  }

  let userSettings = await UserSettings.find({
    _id: { $in: invited }
  });

  let invitedUsersTokens = [];
  for (let user of userSettings) {
    invitedUsersTokens.push(user.fcmToken);
  }

  try {
    const filter = { _id: req.body.eventId };
    const update = { invited: invited };
    let updatedEvent = await Event.findOneAndUpdate(filter, update, {
      new: true, // Flag for returning updated event
      useFindAndModify: false
    });

    let notification = {
      title: "New Event Invitation",
      body: `You have been invited to ${updatedEvent.name} by ${updatedEvent.creator}`
    };
    notifications.notify(notification, invitedUsersTokens);

    let response = {
      message: "Event updated with invited users",
      data: {
        eventId: updatedEvent._id
      }
    };
    resp.json(response);
  } catch (e) {
    console.log(`[error] ${e}`);
    return resp.status(500).send("Can't Invite Users to Event");
  }
};

// get all events within a given radius of given latitude
// and longitude, if event is marked as public
let searchEvent = async function(req, resp) {
  const longitude = req.query.longitude;
  const latitude = req.query.latitude;
  const radius = req.query.radius;

  const lat = Number(latitude);
  const lon = Number(longitude);
  const rad = Number(radius);

  if (!lat || !lon) {
    return resp.status(400).send("no coordinates provided");
  }
  if (!isValidCoordinates(lon, lat)) {
    return resp.status(400).send("invalid coordinates");
  }

  if (!radius) {
    return resp.status(400).send("no radius specified");
  }

  if (radius > 100000) {
    return resp.status(400).send("radius cannot exceed 100,000 (100km)");
  }

  const query = {
    location: {
      $near: {
        $maxDistance: radius,
        $geometry: { type: "Point", coordinates: [longitude, latitude] }
      }
    },
    public: true
  };

  Event.find(query, function(err, events) {
    if (err) {
      console.log(`[error] ${err}`);
      return resp.status(500).send("Could not retrieve events");
    }
    resp.send(events);
  });
};

module.exports = {
  get: getEvent,
  create: createEvent,
  update: updateEvent,
  invite: invitePeople,
  search: searchEvent
};
