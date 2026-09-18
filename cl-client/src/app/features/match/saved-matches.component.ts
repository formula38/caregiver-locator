import { Component, OnInit, inject } from '@angular/core';
import { RouterLink } from '@angular/router';
import { MatchApi } from '../../core/match.api';
import { SessionService } from '../../core/session.service';
import { SavedMatch } from '../../core/models';
import { apiErrorMessage } from '../../core/api.client';

@Component({
  selector: 'app-saved-matches',
  imports: [RouterLink],
  templateUrl: './saved-matches.component.html'
})
export class SavedMatchesComponent implements OnInit {
  private readonly matches = inject(MatchApi);
  private readonly session = inject(SessionService);

  protected error = '';
  protected items: SavedMatch[] = [];
  protected readonly isProvider = this.session.user()?.role === 'provider';
  protected readonly userId = this.session.user()?.id ?? 0;

  ngOnInit(): void {
    this.reload();
  }

  accept(matchId: number): void {
    this.matches.accept(matchId).subscribe({
      next: () => this.reload(),
      error: (err) => {
        this.error = apiErrorMessage(err);
      }
    });
  }

  otherUserId(match: SavedMatch): number {
    return match.recipientId === this.userId ? match.providerId : match.recipientId;
  }

  private reload(): void {
    this.matches.mine().subscribe({
      next: ({ matches }) => {
        this.items = matches;
      },
      error: (err) => {
        this.error = apiErrorMessage(err);
      }
    });
  }
}
