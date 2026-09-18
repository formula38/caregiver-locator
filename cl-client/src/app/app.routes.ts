import { Routes } from '@angular/router';
import { authGuard } from './core/auth.guard';
import { LoginComponent } from './features/auth/login.component';
import { RegisterComponent } from './features/auth/register.component';
import { ProfileComponent } from './features/profile/profile.component';
import { MatchSearchComponent } from './features/match/match-search.component';
import { SavedMatchesComponent } from './features/match/saved-matches.component';
import { ReviewsComponent } from './features/reviews/reviews.component';
import { ThreadsComponent } from './features/messages/threads.component';
import { ThreadComponent } from './features/messages/thread.component';

export const routes: Routes = [
  { path: '', pathMatch: 'full', redirectTo: 'matches' },
  { path: 'login', component: LoginComponent },
  { path: 'register', component: RegisterComponent },
  { path: 'profile', component: ProfileComponent, canActivate: [authGuard] },
  { path: 'matches', component: MatchSearchComponent, canActivate: [authGuard] },
  { path: 'matches/saved', component: SavedMatchesComponent, canActivate: [authGuard] },
  { path: 'reviews', component: ReviewsComponent, canActivate: [authGuard] },
  { path: 'messages', component: ThreadsComponent, canActivate: [authGuard] },
  { path: 'messages/:userId', component: ThreadComponent, canActivate: [authGuard] },
  { path: '**', redirectTo: 'matches' }
];
