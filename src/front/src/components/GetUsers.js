import { useEffect, useState } from "react";
import "../styles/GetUsers.css"

function GetUsers() {
    const [data, setData] = useState([]);

    function fetchData(){
        fetch("https://7wywawxkl5.execute-api.eu-west-3.amazonaws.com/dev/hello").then((response) => response.json())
        .then((fetchedData) => {setData(fetchedData)})
        .catch((err) => {console.log("Error on Get Users :" + err);})
    }

    useEffect(() => {
        fetchData()

    }, []);



    return (
        <ul className="gridLayout">
            {data.map((user) => (
                <li className="card" key={user.id}>
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