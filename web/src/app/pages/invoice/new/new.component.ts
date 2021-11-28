import { Component, OnInit } from '@angular/core';
import { FormBuilder, Validators } from '@angular/forms';
import { MatDialog } from '@angular/material/dialog';
import { InvoiceClientService } from 'src/app/clients/invoice-client.service';
import { InvoiceDetailsComponent } from 'src/app/dialogs/invoice-details/invoice-details.component';
import { CreateInvoiceRequest } from 'src/app/models/invoice/create-invoice-request';
import { CreateInvoiceResponse } from 'src/app/models/invoice/create-invoice-response';
import { AuthService } from 'src/app/services/auth.service';

@Component({
  selector: 'app-new',
  templateUrl: './new.component.html',
  styleUrls: ['./new.component.scss']
})
export class NewComponent implements OnInit {

  invoiceForm = this.fb.group({
    number: [''],
    date: ['', Validators.required],
    company: ['', Validators.required],
    billingFor: ['', Validators.required],
    totalValue: ['', Validators.required],
    sendTo: ['', Validators.required]
  });

  constructor(
    private fb: FormBuilder,
    private invoiceClient: InvoiceClientService,
    private authService: AuthService,
    public dialog: MatDialog
  ) { }

  ngOnInit(): void {
  }

  submit() {
    if (this.invoiceForm.valid) {
      const formValue = this.invoiceForm.value;
      const request: CreateInvoiceRequest = {
        send_to: (<String> formValue.sendTo).split(';'),
        invoice: {
          number: <Number> formValue.number,
          date: <Date> formValue.date,
          company_data: <String> formValue.company,
          billing_for: <String> formValue.billingFor,
          total_value_cents: Number(formValue.totalValue) * 100
        }
      };
      this.invoiceClient.createInvoice(request, <String> this.authService.token).subscribe({
        next: successData => { this.openDetailsDialog(<CreateInvoiceResponse> successData) },
        error: errorData => { console.info('error', errorData); }
      })
    }
  }

  openDetailsDialog(data: CreateInvoiceResponse) {
    const dialogRef = this.dialog.open(InvoiceDetailsComponent, {
      width: '250px',
      data: data,
    });
  }

}
