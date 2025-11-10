import React from 'react'

function App() {
  return (
    <div style={{ padding: '20px', fontFamily: 'Arial' }}>
      <h1>🚀 Senior API Dashboard</h1>
      <p>Frontend is working! Backend connection in progress...</p>
      <div>
        <h2>Services Status:</h2>
        <ul>
          <li>✅ Frontend: Running on port 3001</li>
          <li>🔧 Backend: Connecting...</li>
          <li>🗄️ PostgreSQL: Running on port 5432</li>
          <li>🔴 Redis: Running on port 6379</li>
          <li>📊 ClickHouse: Running on port 8123</li>
        </ul>
      </div>
    </div>
  )
}

export default App