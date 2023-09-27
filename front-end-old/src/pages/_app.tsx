import '@/styles/globals.css'
import type { AppProps } from 'next/app'
import { WagmiConfig, createClient } from 'wagmi'
import { getDefaultProvider } from 'ethers'

export default function App({ Component, pageProps }: AppProps) {

  const client = createClient({
    autoConnect: true,
    provider: getDefaultProvider(1), //change to dynamic
  })

  return<WagmiConfig client={client}>
    <Component {...pageProps} />
  </WagmiConfig>
}

 
