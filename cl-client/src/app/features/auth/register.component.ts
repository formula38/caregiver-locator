import { Component, inject } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { Router, RouterLink } from '@angular/router';
import { AuthApi } from '../../core/auth.api';
import { apiErrorMessage } from '../../core/api.client';
import { UserRole } from '../../core/models';

@Component({
  selector: 'app-register',
  imports: [ReactiveFormsModule, RouterLink],
  templateUrl: './register.component.html'
})
export class RegisterComponent {
  private readonly auth = inject(AuthApi);
  private readonly router = inject(Router);
  private readonly fb = inject(FormBuilder);

  protected error = '';
  protected pending = false;
  protected readonly form = this.fb.nonNullable.group({
    firstName: ['', Validators.required],
    lastName: ['', Validators.required],
    email: ['', [Validators.required, Validators.email]],
    password: ['', [Validators.required, Validators.minLength(8)]],
    role: ['recipient' as UserRole, Validators.required]
  });

  submit(): void {
    if (this.form.invalid) {
      this.form.markAllAsTouched();
      return;
    }
    this.pending = true;
    this.error = '';
    this.auth.register(this.form.getRawValue()).subscribe({
      next: () => {
        this.pending = false;
        void this.router.navigate(['/profile']);
      },
      error: (err) => {
        this.pending = false;
        this.error = apiErrorMessage(err);
      }
    });
  }
}
