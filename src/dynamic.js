const options = {
    method: 'POST',
    mode: 'cors',
    headers: {
      'Content-Type': 'application/json',
    }
  };
    
  fetch('https://911nmu76pd.execute-api.us-east-1.amazonaws.com/test/postCount', options)
    .then(response => {
      if (response.ok) {
        return response.json();
      } else {
        throw new Error('Network Response Error');
      }
    })
    .then(data => {
      document.querySelector('h3').insertAdjacentHTML('beforeend', data.Visits);
    })
    .catch(error => console.log('Error: ', error));