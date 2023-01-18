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

        const back_url = process.env.BACKEND_URL;
        console.log(back_url)
        fetch(back_url, configRequest)
            .then((response) => response.json())
            .then((data) => {
                console.log(data)
                setData(data)
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