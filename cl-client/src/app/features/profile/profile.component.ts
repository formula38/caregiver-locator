import { Component, OnInit, inject } from '@angular/core';
import { FormBuilder, ReactiveFormsModule } from '@angular/forms';
import { ProfileApi } from '../../core/profile.api';
import { apiErrorMessage } from '../../core/api.client';

@Component({
  selector: 'app-profile',
  imports: [ReactiveFormsModule],
  templateUrl: './profile.component.html'
})
export class ProfileComponent implements OnInit {
  private readonly profiles = inject(ProfileApi);
  private readonly fb = inject(FormBuilder);

  protected error = '';
  protected saved = false;
  protected pending = false;
  protected readonly form = this.fb.nonNullable.group({
    location: [''],
    careServices: [''],
    bio: ['']
  });

  ngOnInit(): void {
    this.profiles.mine().subscribe({
      next: ({ profile }) => {
        this.form.patchValue({
          location: profile.location,
          careServices: profile.careServices,
          bio: profile.bio
        });
      },
      error: (err) => {
        this.error = apiErrorMessage(err);
      }
    });
  }

  submit(): void {
    this.pending = true;
    this.error = '';
    this.saved = false;
    this.profiles.updateMine(this.form.getRawValue()).subscribe({
      next: () => {
        this.pending = false;
        this.saved = true;
      },
      error: (err) => {
        this.pending = false;
        this.error = apiErrorMessage(err);
      }
    });
  }
}
