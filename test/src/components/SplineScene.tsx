"use client"
import Spline from "@splinetool/react-spline";
import styled from "styled-components";
import React, { useState, useEffect, Suspense } from "react";
// const Spline = React.lazy(() => import('@splinetool/react-spline'));


export default function App() {
  const [loading, setLoading] = useState(true)
  useEffect(() => {
   console.log("Loading changed");
}, [loading]);
  return (
    <Wrapper>
      {/* {loading && <div>loading</div> }  */}
      <Suspense fallback={<div>Loading...</div>}>
        <Spline scene="https://prod.spline.design/eLaMX0NVnv7qkdm6/scene.splinecode" />
      </Suspense>
      {/* <Spline
        className="spline"
        // onLoad={()=>setLoading(false)} 
        scene="https://prod.spline.design/6lOVYzZBlz9uLPun/scene.splinecode"
        // scene="https://prod.spline.design/j5dLXaZboJc94SRk/scene.splinecode"
      /> */}
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
