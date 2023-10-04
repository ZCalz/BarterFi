"use client"
import Hero  from '../components/Hero'
import { Navbar } from '@/components/Navbar'
import SplineScene from '../components/SplineScene'


export default function Home() {
  return (
    <main className="w-full h-full">
    <Navbar />
    <Hero
      title="Welcome"
      subtitle="join me in my journey"
    />
    </main>
  )
}
