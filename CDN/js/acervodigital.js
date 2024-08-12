const _URL_ = 'http://localhost/museu/'


function getAcervo(token,id_div=''){

    const data = new URLSearchParams()
        data.append("token", token)

    const myRequest = new Request(_URL_+"API/getItens.php",{
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
             
            const main_div = document.getElementById(id_div)
            main_div.classList.add('main-content')
            fetch(_URL_+'CDN/microdata/veiculo.json')
            .then((response)=>{
                response.text(txt).then((txt)=>{
                    const microdata = JSON.parse(txt)

                    function addLine(obj,key,label=''){
                        label = label=='' ? key : label
                        const line = document.createElement('div')
                        line.className = 'row-item'
                        line.innerHTML = `<label>${label}</label><p ${microdata.hasOwnProperty(key) ? `itemprop="${microdata[key]}"` : ''}>${obj[key]}</p>`
                        return line
                    }

                    function addFiles(data){
                        const div = document.createElement('div')
                        div.className = 'img-board'
                        for(let i=0; i<data.files.length; i++){

                            const ext = data.files[i].split('.')[data.files[i].split('.').length -1]
                            const filename = data.files[i].split('.')[0]
                            const arq = ['jpg','jpeg','png'].includes(ext) ? 'img' : 'div'

                            const sqr = document.createElement('div')
                            sqr.className = 'square-item'
                            sqr.src = data.files[i]


                            sqr.innerHTML = ['jpg','jpeg','png'].includes(ext) ? `<img class="img-item" src="${data.files[i]}">` : `<p>${filename}</p><h1>${ext.toUpperCase()}</h1>`

                            div.appendChild(sqr)
                        }
                        return div
                    }


                    for(let i=0; i<json.length; i++){
//console.log(json[i])

                        const imager = addFiles(json[i])
console.log(imager.querySelectorAll('.square-item').length )
                        const content_div = document.createElement('div')
                        content_div.className = 'content-item'                    
                        content_div.setAttribute("itemprop", "itemOffered")
                        content_div.setAttribute("itemscope",true)
                        content_div.setAttribute("itemtype", "https://schema.org/Car")


                        
                        content_div.appendChild(imager)

                        content_div.appendChild(addLine(json[i],'acervo','Acervo:'))
                        content_div.appendChild(addLine(json[i],'alt','Altura:'))
                        content_div.appendChild(addLine(json[i],'ano','Ano:'))
                        content_div.appendChild(addLine(json[i],'cat','Categoria:'))
                        content_div.appendChild(addLine(json[i],'chassi','Chassi:'))
                        content_div.appendChild(addLine(json[i],'cilindrada','Cilindradas:'))
                        content_div.appendChild(addLine(json[i],'cilindros','Cilindros:'))
                        content_div.appendChild(addLine(json[i],'comp','Comprimento:'))
                        content_div.appendChild(addLine(json[i],'cor','Cor:'))
                        content_div.appendChild(addLine(json[i],'entre_eixo','Entre Eixo:'))
                        content_div.appendChild(addLine(json[i],'id'))
                        content_div.appendChild(addLine(json[i],'id_acervo'))
                        content_div.appendChild(addLine(json[i],'id_item'))
                        content_div.appendChild(addLine(json[i],'id_veiculo'))
                        content_div.appendChild(addLine(json[i],'larg','Largura:'))
                        content_div.appendChild(addLine(json[i],'lugares','Lugares:'))
                        content_div.appendChild(addLine(json[i],'marca','Marca:'))
                        content_div.appendChild(addLine(json[i],'modelo','Modelo:'))
                        content_div.appendChild(addLine(json[i],'nome','Nome:'))
                        content_div.appendChild(addLine(json[i],'obs','Obs:'))
                        content_div.appendChild(addLine(json[i],'pais','País:'))
                        content_div.appendChild(addLine(json[i],'placa','Placa:'))
                        content_div.appendChild(addLine(json[i],'portas','Portas:'))
                        content_div.appendChild(addLine(json[i],'pot_hp','Potência HP:'))
                        content_div.appendChild(addLine(json[i],'tipo','Tipo:'))
                        content_div.appendChild(addLine(json[i],'vel_max','Velocidade Máxima:'))

                        main_div.appendChild(content_div)
                    }


                })
            })            
        })
    }
}
