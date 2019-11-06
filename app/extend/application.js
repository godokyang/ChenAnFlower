'use strict';

const fs = require('fs');
const path = require('path');
const jwt = require('jsonwebtoken');

/**
 * json of praramter of generate like this
 * {
 *  username: xxx,
 *  nickname: xxx,
 *  imageurl: xxx,
 * ...
 * }
 */
module.exports = {
  async generateToken(content) {
    // const currentTime = Math.floor(Date.now() / 1000);
    const secretKey = fs.readFileSync(path.resolve(__dirname, '../../config/tokenSecretKey'));
    const token = jwt.sign(content, secretKey, {
      expiresIn: '72h',
    });

    return token;
  },
  async verifyToken(token) {
    const secretKey = fs.readFileSync(path.resolve(__dirname, '../../config/tokenSecretKey'));
    try {
      const decode = jwt.verify(token, secretKey);
      return Object.assign({ status: true }, decode);
    } catch (error) {
      return Object.assign({ status: false }, { error });
    }
  },
};
