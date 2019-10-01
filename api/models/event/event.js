/**
 * Event object constructor
 *
 * @param {Location} location - location of the event
 * @param {string} creator - creator user id
 * @param {string[]} organizers - array of organizer user IDs
 *
 * @returns {Event}
 */
function Event(location, creator, organizers) {
	this.location = location;
	this.creator = creator;
	this.organizers = organizers;
}
