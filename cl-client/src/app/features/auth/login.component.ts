import { Component, inject } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { AuthApi } from '../../core/auth.api';
import { apiErrorMessage } from '../../core/api.client';

@Component({
  selector: 'app-login',
  imports: [ReactiveFormsModule, RouterLink],
  templateUrl: './login.component.html'
})
export class LoginComponent {
  private readonly auth = inject(AuthApi);
  private readonly router = inject(Router);
  private readonly fb = inject(FormBuilder);

  protected error = '';
  protected pending = false;
  protected readonly form = this.fb.nonNullable.group({
    email: ['', [Validators.required, Validators.email]],
    password: ['', Validators.required]
  });

  submit(): void {
    if (this.form.invalid) {
      this.form.markAllAsTouched();
      return;
    }
    this.pending = true;
    this.error = '';
    const { email, password } = this.form.getRawValue();
    this.auth.login(email, password).subscribe({
      next: () => {
        this.pending = false;
        void this.router.navigate(['/matches']);
      },
      error: (err) => {
        this.pending = false;
        this.error = apiErrorMessage(err);
      }
    });
  }
}
