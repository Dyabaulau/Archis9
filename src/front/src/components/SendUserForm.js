import '../styles/SendUserForm.css'
import { useState } from "react";

function SendUserForm() {

    const [variables, setVariables] = useState({
        lastName: "",
        firstName: "",
        age: 0,
        profession: "",
    })

    function handleChange(evt) {
        const value = evt.target.value;
        setVariables({
            ...variables,
            [evt.target.name]: value
        });
    }

    const sendRequest = async () => {

        const requestOptions = {
            method: 'POST',
            headers:
            {
                'Content-Type': 'application/json',
                'Accept': 'application/json'
            },
            body: JSON.stringify(
                {
                    firstName: variables.firstName,
                    lastName: variables.lastName,
                    age: variables.age,
                    profession: variables.profession
                }
            )

        };

        try {
            const response = await fetch("https://7wywawxkl5.execute-api.eu-west-3.amazonaws.com/dev/hello", requestOptions);
            const data = await response.json();
            console.log(data)
        }
        catch (err) {
            console.log("Error on Post User :" + err);
        }
    }

    return (
        <div className='form-content'>
            <div id='parent'>
                <fieldset>
                    <form id='user-form'>
                        <label id='form-label'>
                            <strong>FirstName :</strong>
                            <textarea name="firstName" value={variables.firstName} onChange={handleChange} />
                        </label>
                        <label id='form-label'>
                            <strong>LastName :</strong>
                            <textarea name="lastName" value={variables.lastName} onChange={handleChange} />
                        </label>
                        <label id='form-label'>
                            <strong>Age :</strong>
                            <textarea name="age" value={variables.age} onChange={handleChange} />
                        </label>
                        <label id='form-label'>
                            <strong>Profession :</strong>
                            <textarea name="profession" value={variables.profession} onChange={handleChange} />
                        </label>

                        <button id="submitbutton" type="button" onClick={sendRequest}>Submit</button>
                    </form>
                </fieldset>
            </div>
        </div>
    );
}

export default SendUserForm;