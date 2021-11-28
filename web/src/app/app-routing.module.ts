import { NgModule } from '@angular/core';
import { RouterModule, Routes } from '@angular/router';
import { AuthGuard } from './gards/auth.guard';
import { CreateTokenComponent } from './pages/auth/create-token/create-token.component';

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
      },
      {
        path: 'create-token',
        component: CreateTokenComponent
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
