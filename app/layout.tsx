import type { Metadata } from 'next';
import './globals.css';
export const metadata: Metadata = { title:'RideMate — Better rides, together', description:'A verified campus carpooling community. Find rides, share costs and travel together.' };
export default function RootLayout({children}:{children:React.ReactNode}) { return <html lang="en"><body>{children}</body></html>; }
