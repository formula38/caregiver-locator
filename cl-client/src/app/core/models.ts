export type UserRole = 'recipient' | 'provider';

export interface User {
  id: number;
  firstName: string;
  lastName: string;
  email: string;
  role: UserRole;
}

export interface Profile {
  id: number;
  userId: number;
  firstName: string;
  lastName: string;
  email: string;
  role: UserRole;
  careServices: string;
  location: string;
  rating: number;
  bio: string;
}

export interface ProviderMatch {
  id: number;
  firstName: string;
  lastName: string;
  email: string;
  role: UserRole;
  careServices: string;
  location: string;
  rating: number;
  bio: string;
}

export interface SavedMatch {
  id: number;
  recipientId: number;
  providerId: number;
  status: 'pending' | 'accepted' | 'declined';
  createdAt: string;
  recipientName?: string;
  providerName?: string;
}

export interface Review {
  id: number;
  reviewerId: number;
  revieweeId: number;
  rating: number;
  comment: string;
  createdAt: string;
  reviewerName?: string;
}

export interface Message {
  id: number;
  senderId: number;
  receiverId: number;
  messageText: string;
  sentAt: string;
}

export interface ThreadSummary {
  userId: number;
  name: string;
  lastMessage: string;
  sentAt: string;
}

export interface ApiEnvelope<T> {
  ok: boolean;
  data?: T;
  error?: string;
  errors?: string[];
}
