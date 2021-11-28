import { TestBed } from '@angular/core/testing';

import { InvoiceClientService } from './invoice-client.service';

describe('InvoiceClientService', () => {
  let service: InvoiceClientService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(InvoiceClientService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
