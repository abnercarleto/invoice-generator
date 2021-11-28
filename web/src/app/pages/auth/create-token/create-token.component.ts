import { Component, OnInit } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import { MatSnackBar } from '@angular/material/snack-bar';
import { InvoiceClientService } from 'src/app/clients/invoice-client.service';

@Component({
  selector: 'app-create-token',
  templateUrl: './create-token.component.html',
  styleUrls: ['./create-token.component.scss']
})
export class CreateTokenComponent implements OnInit {

  createTokenForm = this.fb.group({
    email: ['', Validators.required],
    permitRegenerate: ['']
  });

  constructor(
    private fb: FormBuilder,
    private invoiceClient: InvoiceClientService,
    private snackBar: MatSnackBar
  ) { }

  ngOnInit(): void {
  }

  submit() {
    const formValue = this.createTokenForm.value;
    this.invoiceClient.createToken(formValue.email, formValue.permitRegenerate).subscribe({
      next: successData => {
        this.snackBar.open(`Your token was sent to ${successData.sent_to}`, 'ok');
      },
      error: errorData => {
        if (errorData.error.token_already_generated == true) {
          this.snackBar.open(`Has a previous token generated`, 'ok');
        }
      }
    });
  }

}
