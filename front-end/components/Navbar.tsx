"use client"
import React,  { useState, useEffect } from 'react'
import Image from 'next/image'
import Link from 'next/link'
import logo from '../public/vercel.svg'
import { AiOutlineMenu, AiOutlineClose } from 'react-icons/ai'
import { HiAcademicCap } from "react-icons/hi";
const Button = (prop:{path: string}) => {
  return(<button className="p-4">
        <Link href={`/${prop.path}`}>
            <li className="uppercase hover:font-bold">{prop.path}</li>
        </Link>
  </button>)
}
export const Navbar = (prop:{ additionalAttributes?: string }) => {
    const [openMenu, setOpenMenu] = useState(false)
    const [isScrolled, setIsScrolled] = useState(false);

    useEffect(() => {
      const handleScroll = () => {
        const scrollTop = window.pageYOffset;
  
        if (scrollTop > 95 && !isScrolled) {
          setIsScrolled(true);
        } else if (scrollTop === 0 && isScrolled) {
          setIsScrolled(false);
        }
      };
  
      window.addEventListener('scroll', handleScroll);
  
      return () => {
        window.removeEventListener('scroll', handleScroll);
      };
    }, [isScrolled]);

    const handleNav =()=> {
        setOpenMenu(!openMenu)
    }
  return (
    // {`fixed top-0 left-0 right-0 z-50 transition-transform duration-300 ${
    //   isScrolled ? 'transform translate-x-0' : 'transform translate-x-full'
    // }`}
    // <nav className="p-4 flex w-full h-24 bg-black text-white sticky top-0 left-0 right-0 z-40 backdrop-blur-sm backdrop-filter bg-opacity-20">
    <nav className={` font-sans p-4 flex w-full h-24 bg-black text-white ${!isScrolled ? '' : 'sticky top-0 left-0 right-0 z-50'}`}>
      <div className="flex justify-between items-center h-full w-full px-4 2xl:px-16">
        <Link className="flex" href="/">
          <HiAcademicCap size={45}/>
        <Image 
        src={logo}
        alt="logo"
        height="205"
        width="75"
        className="cursor-pointer"
        priority
        />
        </Link>

      <ul className="hidden sm:flex">
        <Button path="About"/>
        {/* <Button path="Contact"/> */}
        <Button path="Services"/>
        {/* <Button path="Blog"/> */}
        <Button path="JourneyPage"/>
        {/* <Button path="DApps"/> */}
      </ul>

      <div onClick={handleNav} className="sm:hidden cursor-pointer pl-24">
        <AiOutlineMenu size={25}/>

      </div>
      </div>
      <div className={
        openMenu? "fixed top-0 left-0 sm:hidden h-screen w-[65%] bg-[#5434] p-10 ease-in duration-500" : 
        "fixed top-0 left-[-100%] p-10 ease-in duration-500"
      }>
        <div className="flex w-full place-items-center justify-end">
            <div onClick={handleNav} className="cursor-pointer">
                <AiOutlineClose size={25} />
            </div>
        </div>
        <div className="hiddle sm:flex-column py-4">
      <ul>
        <Link href="/About">
            <li className="ml-10 uppercase hover:border-b text:ml">About</li>
        </Link>
        <Link href="/Contact">
            <li className="ml-10 uppercase hover:border-b text:ml">Contact</li>
        </Link>
        <Link href="/Services">
            <li className="ml-10 uppercase hover:border-b text:ml">Services</li>
        </Link>
      </ul>
      </div>
      </div>
    </nav>
  )
}

// export default Navbar