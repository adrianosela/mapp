const { OAuth2Client } = require('google-auth-library');

const defaultScope = [
  'https://www.googleapis.com/auth/userinfo.profile',
  'https://www.googleapis.com/auth/userinfo.email',
];

class Authenticator {
  constructor() {}
 
  initialize(cid, csecret, redirUrl) {
    this.oauth2client = new OAuth2Client(cid, csecret, redirUrl);
    this.url = this.oauth2client.generateAuthUrl({
      access_type: 'offline',
      prompt: 'consent',
      scope: defaultScope
    });
    console.log('[info] successfully initialized google auth client');
  }
  
  getUrl() {
    return this.url;
  }

  async getGoogleUser(code) {
    const data = await this.oauth2client.getToken(code)
    this.oauth2client.setCredentials(data.tokens);
    const url = 'https://people.googleapis.com/v1/people/me?personFields=names,emailAddresses';
    const res = await this.oauth2client.request({url});
    
    return res.data;
  }
}

let authenticator = new Authenticator();
module.exports = authenticator;
