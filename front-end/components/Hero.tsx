"use client"
import React from 'react'
import Spline from '@splinetool/react-spline';
import SplineScene from '../components/SplineScene';

interface Props {
  title: string
  subtitle: string
}

const Hero: React.FC<Props> = ({ title, subtitle }) => {
  return (
    <div className="relative bg-gray-800">
          <Spline
        className="min-h-screen min-w-fit h-full"
         scene="https://prod.spline.design/j5dLXaZboJc94SRk/scene.splinecode" />
       <div className="absolute top-0 left-0 right-0 h-12 shadow-2xl bg-black z-10 backdrop-blur-sm backdrop-filter bg-opacity-10"></div>
      <div className="relative z-10 flex flex-col items-center justify-center h-screen max-w-7xl mx-auto">
        <h1 className="text-9xl font-bold text-white px-6 font-monoton">{title}</h1>
        <p className="mt-4 text-3xl text-white">{subtitle}</p>
      </div>
      <div className="absolute bottom-0 left-0 right-0 h-6 shadow-2xl bg-black z-10 backdrop-blur-sm backdrop-filter bg-opacity-10"></div>
    </div>
  )
}

export default Hero