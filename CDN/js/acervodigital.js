const API_URL = 'http://localhost/museu/API/'


function getAcervo(token,id_div=''){

    const data = new URLSearchParams()
        data.append("token", token)

    const myRequest = new Request(API_URL+"getItens.php",{
        method : "POST",
        body : data
    });

    const out = new Promise((resolve,reject) =>{
        fetch(myRequest)
        .then(function (response){
            if (response.status === 200) { 
                resolve(response.text())        
            } else { 
                reject(new Error("Houve algum erro na comunicação com o servidor"));
            } 
        })
    })

    if(id_div == ""){
        return out
    }else{
        out.then((txt)=>{
            const json = JSON.parse(txt)
console.log(json)                        
            const main_div = document.getElementById(id_div)
            main_div.classList.add('main-content')
            
            function addLine(label,value){
                const line = document.createElement('div')
                line.className = 'row-item'
                const lbl = document.createElement('label')
                lbl.innerHTML = label
                line.appendChild(lbl)
                const vl = document.createElement('p')
                vl.innerHTML = value
                line.appendChild(vl)

                return line
            }

            for(let i=0; i<json.length; i++){

                const content_div = document.createElement('div')
                content_div.className = 'content-item'
    
/*
                const div = document.createElement('div')
                const nome = document.createElement('div')
                nome.innerHTML = `<p>Acervo:</p><p id="nome-acervo">${json[i].acervo}</p>
                                <img src="${json[i].files[0]}"/>`
            
                div.appendChild(nome)
*/    
                content_div.appendChild(addLine('Nome:',json[i].nome))
                content_div.appendChild(addLine('Descrição:',json[i].obs))
                content_div.appendChild(addLine('Ano::',json[i].ano))
                content_div.appendChild(addLine('Chassi:',json[i].chassi))
                content_div.appendChild(addLine('Marca:',json[i].marca))

                main_div.appendChild(content_div)
            }

            
        })
    }
}
