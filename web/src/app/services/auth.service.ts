import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  isLoggedIn: Boolean = false;
  token: String | undefined | null = null;

  redirectUrl: string | null = null;

  constructor() { }

  setLoggedIn(token: String) {
    this.isLoggedIn = true;
    this.token = token;
  }

  setLoggedOut() {
    this.isLoggedIn = false;
  }
}
