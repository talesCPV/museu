const API_URL = 'http://localhost/museu/API/'


function getAcervo(token,id_div){

    const data = new URLSearchParams()
        data.append("token", token)

    const myRequest = new Request(API_URL+"getItens.php",{
        method : "POST",
        body : data
    });

    const myPromisse = new Promise((resolve,reject) =>{
        fetch(myRequest)
        .then(function (response){
            if (response.status === 200) { 
                resolve(response.text())        
            } else { 
                reject(new Error("Houve algum erro na comunicação com o servidor"));
            } 
        })
    })

    myPromisse.then((txt)=>{
        const json = JSON.parse(txt)
        const main_div = document.getElementById(id_div)
        for(let i=0; i<json.length; i++){
            const div = document.createElement('div')
            const nome = document.createElement('div')
            nome.innerHTML = `<p>Acervo:</p><p id="nome-acervo">${json[i].acervo}</p>
                            <img src="${json[i].files[0]}"/>`
        
            div.appendChild(nome)

            main_div.appendChild(div)
        }

    })

}
