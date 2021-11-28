import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AuthGuard } from './gards/auth.guard';

import { LoginComponent } from './pages/auth/login/login.component';
import { NewComponent as InvoiceNewComponent } from './pages/invoice/new/new.component';

const routes: Routes = [
  {
    path: '',
    redirectTo: '/invoices/new',
    pathMatch: 'full'
  },
  {
    path: 'auth',
    children: [
      {
        path: 'login',
        component: LoginComponent
      }
    ]
  },
  {
    path: 'invoices',
    canActivate: [AuthGuard],
    children: [
      {
        path: 'new',
        component: InvoiceNewComponent
      }
    ]
  }
];

@NgModule({
  imports: [RouterModule.forRoot(routes)],
  exports: [RouterModule]
})
export class AppRoutingModule { }
