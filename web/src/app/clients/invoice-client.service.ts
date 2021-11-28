import { HttpClient, HttpHeaders } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { CreateInvoiceRequest } from '../models/invoice/create-invoice-request';
import { CreateInvoiceResponse } from '../models/invoice/create-invoice-response';

@Injectable({
  providedIn: 'root'
})
export class InvoiceClientService {
  private baseUrl = 'http://localhost:3000/api/v1'

  private headers = new HttpHeaders({
    'Content-Type': 'application/json',
    'Accept': 'application/json'
  });

  constructor(private httpClient: HttpClient) { }

  login(token: string): Observable<any> {
    return this.httpClient.get(`${this.baseUrl}/auth/validate`, {
      headers: this.headers,
      params: { token: token }
    });
  }

  createInvoice(invoiceRequest: CreateInvoiceRequest, authToken: String): Observable<CreateInvoiceResponse> {
    return this.httpClient.post<CreateInvoiceResponse>(`${this.baseUrl}/invoices`, invoiceRequest, {
      headers: this.headers.append('x-auth-token', <string> authToken)
    });
  }
}
