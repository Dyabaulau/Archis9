import { useEffect, useState } from "react";
import "../styles/GetUsers.css"

function GetUsers() {
    const [data, setData] = useState([]);
    const [env, setEnv] = useState({});

    function fetchData() {

        const configRequest = {
            method: 'GET',
            headers:
            {
                'Content-Type': 'application/json',
                'Accept': 'application/json',
                'Access-Control-Allow-Origin': '*', // This is the important part
            }

        };

        fetch('https://balapp-archi-front.s3.amazonaws.com/config.env', configRequest)
            .then(response => response.text())
            .then(text => {
                console.log(text)
                const env = text.split('=')[1]
                console.log(env)
                setEnv({ env });
                console.log(env)
                return fetch(env)
            }).then((response) => response.json())
            .then((fetchedData) => {
                console.log(fetchedData)
                setData(fetchedData)
            })
            .catch((err) => { console.log("Error on Get Users :" + err); })
    }

    useEffect(() => {
        fetchData()
    }, []);



    return (
        <ul className="gridLayout">
            {data.map((user) => (
                <li className="card" key={user.uuid}>
                    <p>Firstname: {user.firstName}</p>
                    <p>Lastname: {user.lastName}</p>
                    <p>Age: {user.age}</p>
                    <p>Profession: {user.profession}</p>
                </li>
            ))}
        </ul>
    );
}

export default GetUsers;