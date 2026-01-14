// script.js
const http = require('http');
const fs = require('fs');
const sql = require('mssql');

const dbConfig = {
    user: 'gym_user',
    password: 'StrongPass@123',
    database: 'GymDB',
    server: 'localhost',
    options: {
        trustServerCertificate: true
    }
};

const server = http.createServer(async (req, res) => {
    if (req.method === 'GET' && req.url === '/') {
        res.writeHead(200, { 'Content-Type': 'text/html' });
        res.end(fs.readFileSync('index.html'));
        return;
    }

    if (req.method === 'GET' && req.url === '/style.css') {
        res.writeHead(200, { 'Content-Type': 'text/css' });
        res.end(fs.readFileSync('style.css'));
        return;
    }

    if (req.url.startsWith('/members')) {
        await sql.connect(dbConfig);

        if (req.method === 'GET') {
            const result = await sql.query('SELECT * FROM Members');
            res.writeHead(200, { 'Content-Type': 'application/json' });
            res.end(JSON.stringify(result.recordset));
        }

        if (req.method === 'POST') {
            let body = '';
            req.on('data', chunk => body += chunk);
            req.on('end', async () => {
                const { name, age, membershipType } = JSON.parse(body);
                await sql.query`
                    INSERT INTO Members (name, age, membershipType)
                    VALUES (${name}, ${age}, ${membershipType})
                `;
                res.end();
            });
        }

        if (req.method === 'PUT') {
            const id = req.url.split('/')[2];
            let body = '';
            req.on('data', chunk => body += chunk);
            req.on('end', async () => {
                const { name, age, membershipType } = JSON.parse(body);
                await sql.query`
                    UPDATE Members
                    SET name=${name}, age=${age}, membershipType=${membershipType}
                    WHERE id=${id}
                `;
                res.end();
            });
        }

        if (req.method === 'DELETE') {
            const id = req.url.split('/')[2];
            await sql.query`DELETE FROM Members WHERE id=${id}`;
            res.end();
        }
    }
});

server.listen(3000);v