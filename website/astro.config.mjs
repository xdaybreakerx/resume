import { defineConfig } from 'astro/config'
import mdx from '@astrojs/mdx'
import tailwind from '@astrojs/tailwind'
import sitemap from '@astrojs/sitemap'
import expressiveCode from 'astro-expressive-code'
import { expressiveCodeOptions } from './src/site.config'
import icon from 'astro-icon'


import react from '@astrojs/react';


// https://astro.build/config
export default defineConfig({
    site: 'https://resume.xandersalathe.com',
    integrations: [expressiveCode(expressiveCodeOptions), tailwind({
        applyBaseStyles: false
		}), sitemap(), mdx(), icon(), react()],
    
    // prefetch: true,
    // output: 'server',
    // adapter: vercel({
    // 	webAnalytics: { enabled: true }
    // })
})