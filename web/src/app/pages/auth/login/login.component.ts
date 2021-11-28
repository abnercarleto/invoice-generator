import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormControl, FormGroup, Validators } from '@angular/forms';
import { MatSnackBar } from '@angular/material/snack-bar';
import { Router } from '@angular/router';
import { catchError } from 'rxjs';
import { InvoiceClientService } from 'src/app/clients/invoice-client.service';
import { AuthService } from 'src/app/services/auth.service';

@Component({
  selector: 'app-login',
  templateUrl: './login.component.html',
  styleUrls: ['./login.component.scss']
})
export class LoginComponent implements OnInit {

  loginForm = this.fb.group({
    token: ['', Validators.required]
  });

  constructor(
    private fb: FormBuilder,
    private invoiceClient: InvoiceClientService,
    private snackBar: MatSnackBar,
    private router: Router,
    private authService: AuthService
  ) { }

  ngOnInit(): void {
  }

  submit(): void {
    this.invoiceClient.login(this.loginForm.value.token).subscribe({
      next: successData => {
        this.authService.setLoggedIn();
        this.router.navigate(['/invoices/new']);
      },
      error: errorData => {
        if (errorData.status == 401) {
          this.snackBar.open('Invalid token', 'ok');
          return
        }

        this.snackBar.open('Unexpected error', 'ok');
      }
    })
  }

}
