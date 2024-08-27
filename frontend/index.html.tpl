<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>TODO App</title>
    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            max-width: 600px;
            margin: 0 auto;
            padding: 20px;
            background-color: #1e272e;
            color: #d2dae2;
        }
        h1 {
            text-align: center;
            color: #ff9ff3;
            text-shadow: 0 0 10px rgba(255,159,243,0.5);
        }
        .input-container {
            display: flex;
            margin-bottom: 20px;
        }
        input[type="text"] {
            flex-grow: 1;
            padding: 12px;
            font-size: 16px;
            border: none;
            border-radius: 4px 0 0 4px;
            background-color: #485460;
            color: #d2dae2;
        }
        input[type="text"]::placeholder {
            color: #808e9b;
        }
        button {
            padding: 12px 20px;
            font-size: 16px;
            background-color: #0abde3;
            color: #1e272e;
            border: none;
            cursor: pointer;
            transition: all 0.3s;
        }
        button:hover {
            background-color: #48dbfb;
            transform: translateY(-2px);
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
        }
        #addBtn {
            border-radius: 0 4px 4px 0;
        }
        ul {
            list-style-type: none;
            padding: 0;
        }
        li {
            background-color: #2f3640;
            margin-bottom: 15px;
            padding: 15px;
            border-radius: 4px;
            display: flex;
            align-items: center;
            box-shadow: 0 4px 6px rgba(0,0,0,0.1);
            transition: all 0.3s;
        }
        li:hover {
            transform: translateY(-2px);
            box-shadow: 0 6px 8px rgba(0,0,0,0.15);
        }
        li input[type="checkbox"] {
            margin-right: 15px;
            transform: scale(1.2);
        }
        li span {
            flex-grow: 1;
            font-size: 18px;
        }
        li button {
            padding: 8px 12px;
            font-size: 14px;
            background-color: #ff6b6b;
        }
        li button:hover {
            background-color: #ee5253;
        }
    </style>
</head>
<body>
    <h1>TODO App in {{ENVIRONMENT_NAME}}</h1>
    <div class="input-container">
        <input type="text" id="newTodo" placeholder="Enter a new todo">
        <button id="addBtn" onclick="addTodo()">Add</button>
    </div>
    <ul id="todoList"></ul>

    <script>
        const API_URL = 'https://{{API_URL}}/api';  // Update this to match your backend URL

        async function fetchTodos() {
            const response = await fetch(`${API_URL}/todos`);
            const todos = await response.json();
            const todoList = document.getElementById('todoList');
            todoList.innerHTML = '';
            todos.forEach(todo => {
                const li = document.createElement('li');
                li.innerHTML = `
                    <input type="checkbox" ${todo.completed ? 'checked' : ''} onchange="updateTodo(${todo.id}, this.checked)">
                    <span>${todo.title}</span>
                    <button onclick="deleteTodo(${todo.id})">Delete</button>
                `;
                todoList.appendChild(li);
            });
        }

        async function addTodo() {
            const input = document.getElementById('newTodo');
            const title = input.value.trim();
            if (title) {
                await fetch(`${API_URL}/todos`, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify({ title })
                });
                input.value = '';
                fetchTodos();
            }
        }

        async function updateTodo(id, completed) {
            await fetch(`${API_URL}/todos/${id}`, {
                method: 'PUT',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ completed })
            });
            fetchTodos();
        }

        async function deleteTodo(id) {
            await fetch(`${API_URL}/todos/${id}`, { method: 'DELETE' });
            fetchTodos();
        }

        fetchTodos();
    </script>
</body>
</html>