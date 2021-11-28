import { Injectable } from '@angular/core';

@Injectable({
  providedIn: 'root'
})
export class AuthService {
  isLoggedIn = false;

  redirectUrl: string | null = null;

  constructor() { }

  setLoggedIn() {
    this.isLoggedIn = true;
  }

  setLoggedOut() {
    this.isLoggedIn = false;
  }
}
