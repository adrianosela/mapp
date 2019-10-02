const { OAuth2Client } = require('google-auth-library');

/**
 * the scopes listed below dictate what permissions
 * Google will ask the user for consent for
 */
const defaultScope = [
  'https://www.googleapis.com/auth/userinfo.profile',
  'https://www.googleapis.com/auth/userinfo.email',
];

// Url to get user profile with an authenticated client (using user's access token)
const fetchProfileUrl = 'https://www.googleapis.com/oauth2/v1/userinfo?alt=json';

/**
 * Authenticator is a Google authenticator class
 * responsible for retrieving, and verifying user
 * auth tokens from Google.
 */
class Authenticator {
  constructor() { /* NOP */ }
    
  /**
   * Sets Google admin API credentials and generates
   * the URL through which Mapp users will authenticate
   * against Google.
   *
   * @param {string} cid - Google Admin API ClientID
   * @param {string} csecret - Google Admin API ClientSecret
   * @param {string} redirUrl - The callback URL where authenticated
   *                            users come back to with a token (where 
   *                            Google redirects users to after they
   *                            have successfully authenticated
   */
  initialize(cid, csecret, redirUrl) {
    this.clientId = cid;
    this.clientSecret = csecret;
    this.redirectUrl = redirUrl;
    const client = new OAuth2Client(cid, csecret, redirUrl);
    this.url = client.generateAuthUrl({
      access_type: 'offline',
      prompt: 'consent',
      scope: defaultScope
    });
    console.log('[info] successfully initialized google auth client');
  }
  
  /**
   * Returns the URL where users must consent to using Mapp
   */
  getGoogleAuthUrl() {
    return this.url;
  }

  /**
   * Returns the id, access, and refresh tokens for the user
   *
   * @param {string} code - 'Authorization successful code' from Google
   *                        with which we can fetch the user's auth tokens
   */
  async getGoogleAuthTokens(code) {
    const client = new OAuth2Client(this.clientId, this.clientSecret, this.redirectUrl);
    const data = await client.getToken(code);
    return data.tokens;
  }

  /**
   * Returns the user profile (with the default scopes above the Authenticator class)
   *
   * @param {string} accessToken - the user's access token to Google APIs
   */
  async getGoogleUserProfile(accessToken) {
    const client = new OAuth2Client(this.clientId, this.clientSecret, this.redirectUrl);
    client.setCredentials({access_token: accessToken});
    const res = await client.request({url: fetchProfileUrl});
    return res.data;
  }
}

let authenticator = new Authenticator();
module.exports = authenticator;
