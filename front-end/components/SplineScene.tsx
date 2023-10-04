"use client"
import Spline from "@splinetool/react-spline";
import styled from "styled-components";
import React, { useState, useEffect } from "react";
import { Button } from "@material-tailwind/react";
export default function App() {
  const [loading, setLoading] = useState(true)
  useEffect(() => {
   console.log("Loading changed");
}, [loading]);
  return (
    <Wrapper>
      <Spline
      onLoad={()=>setLoading(false)}
        className="spline"
        scene="https://prod.spline.design/6lOVYzZBlz9uLPun/scene.splinecode"
      />
      <button onClick={()=>{
        console.log("pressed")
        setLoading(!loading)}}>PRESS</button>
    </Wrapper>
  );
}

const Wrapper = styled.div`
  width: 100%;
  height: 100%;
  min-height: 720px;

  @media (max-width: 560px) {
    min-height: 520px;
  }
`;
