import { Component, OnInit, inject } from '@angular/core';
import { FormBuilder, ReactiveFormsModule, Validators } from '@angular/forms';
import { ReviewApi } from '../../core/review.api';
import { Review } from '../../core/models';
import { apiErrorMessage } from '../../core/api.client';

@Component({
  selector: 'app-reviews',
  imports: [ReactiveFormsModule],
  templateUrl: './reviews.component.html'
})
export class ReviewsComponent implements OnInit {
  private readonly reviewsApi = inject(ReviewApi);
  private readonly fb = inject(FormBuilder);

  protected error = '';
  protected items: Review[] = [];
  protected readonly form = this.fb.nonNullable.group({
    revieweeId: [0, [Validators.required, Validators.min(1)]],
    rating: [5, [Validators.required, Validators.min(1), Validators.max(5)]],
    comment: ['']
  });

  ngOnInit(): void {
    this.reload();
  }

  submit(): void {
    if (this.form.invalid) {
      this.form.markAllAsTouched();
      return;
    }
    const { revieweeId, rating, comment } = this.form.getRawValue();
    this.reviewsApi.create(revieweeId, rating, comment).subscribe({
      next: () => {
        this.form.patchValue({ comment: '' });
        this.reload();
      },
      error: (err) => {
        this.error = apiErrorMessage(err);
      }
    });
  }

  private reload(): void {
    this.reviewsApi.list().subscribe({
      next: ({ reviews }) => {
        this.items = reviews;
      },
      error: (err) => {
        this.error = apiErrorMessage(err);
      }
    });
  }
}
