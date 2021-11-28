import { Component, Inject, OnInit } from '@angular/core';
import {MatDialogRef, MAT_DIALOG_DATA} from '@angular/material/dialog';
import { CreateInvoiceResponse } from 'src/app/models/invoice/create-invoice-response';

@Component({
  selector: 'app-invoice-details',
  templateUrl: './invoice-details.component.html',
  styleUrls: ['./invoice-details.component.scss']
})
export class InvoiceDetailsComponent implements OnInit {

  constructor(
    public dialogRef: MatDialogRef<InvoiceDetailsComponent>,
    @Inject(MAT_DIALOG_DATA) public data: CreateInvoiceResponse,
  ) { }

  ngOnInit(): void {
  }

  closeClick(): void {
    this.dialogRef.close();
  }

}
