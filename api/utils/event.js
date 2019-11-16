let friendsGoingToEvent = function(user, event) {
    if (event == null) {
        return 0;
    }

    let userFriends = user.following;
    let attendingEvent = event.followers;

    let attendingFriends = 0;
    for (let friend of userFriends) {
        if (attendingEvent.includes(friend)) {
            attendingFriends++;
        }
    }

    return attendingFriends;
};

let getRelevantEventsForUser = function(events, user, limit = 50) {
    for (let event of events) {
        event.attendingFriends = friendsGoingToEvent(user, event);
    }

    events.sort(function(eventA, eventB) {
        if ((eventA.attendingFriends > 0) || (eventB.attendingFriends > 0)) {
            return eventB.attendingFriends - eventA.attendingFriends;
        }

        return eventB.followers.length - eventA.followers.length;
    });

    if (limit > events.length) {
        limit = events.length;
    }

    events.splice(limit);
    return events;
};

module.exports = {
    friendsGoing: friendsGoingToEvent,
    relevantForUser: getRelevantEventsForUser
};
