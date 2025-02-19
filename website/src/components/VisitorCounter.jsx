import { useState, useEffect } from 'react'

function VisitorCounter() {
	const [counter, setCounter] = useState(null)

	useEffect(() => {
		async function fetchCounter() {
			try {
				const res = await fetch(
					'https://libynmctxva4fytmw42hm3mn4y0ntqxs.lambda-url.us-east-1.on.aws/'
				)
				const data = await res.json()
				setCounter(data)
				console.log('Counter:', data)
			} catch (error) {
				console.error('Failed to fetch counter:', error)
			}
		}

		fetchCounter()
	}, [])

	return (
		<div>
			<p className='text-sm text-muted-foreground'>
				Visitors: {counter !== null ? counter : 'Loading...'}
			</p>
		</div>
	)
}

export default VisitorCounter
