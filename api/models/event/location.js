/**
 * Location object constructor
 *
 * @param {number} latitude - latitude of the event
 * @param {number} longitude - longitude of the event
 * @param {number} radius - radius (in meters) of the event
 *
 * @returns {Location}
 */
function Location(latitude, longitude, radius) {
  this.coordinates = {
     latitude : latitude,
     longitude : longitude
  };
  this.radius = radius;
}
