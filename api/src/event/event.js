/**
 * Event object constructor
 *
 * @param {Location} loc - location of the event
 * @param {string} cre - creator user id
 * @param {string[]} org - array of organizer user IDs
 *
 * @returns {Event}
 */
function Event(loc, cre, org) {
	this.location = loc;
	this.creator = cre;
	this.organizers = org;
}
