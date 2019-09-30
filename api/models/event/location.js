/**
 * Location object constructor
 *
 * @param {number} lat - latitude of the event
 * @param {number} lon - longitude of the event
 * @param {number} rad - radius (in meters) of the event
 *
 * @returns {Location}
 */
function Location(lat, lon, rad) {
  this.coordinates = {
     latitude : lat,
     longitude : lon
  };
  this.radius = rad;
}
