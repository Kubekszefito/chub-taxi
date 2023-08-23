$(document).ready(function(){
    window.addEventListener('message', (event) => {
        switch (event.data.type){
            case 'show-taxi':
                $('.window').show()
            break
            case 'hide-taxi':
                $('.window').hide()
            break
            case 'add-taxi':
                addTaxi(event.data.data)
                // console.log(JSON.stringify(event.data.coords))
            break
        }
    });

    $(document).on("keydown", function(event) {
        const { keyCode } = event;
        switch (keyCode) {
            case 27:
                $.post(`https://${GetParentResourceName()}/exit`, JSON.stringify({}));
            break;
        }
    });

    function addTaxi(data){
        // console.log(coords)
        $('.conteiner').empty()

        for (let i = 0; i < data.length; i++) {
            let call = data[i]

            let string = `
            <div id="taxi-call" class="call-${call.id}">
                <div class="call-title"><p>Obywatel wezwał taxi!-${call.id}</p></div>
                <div class="streetname"><p>${call.street}</p></div>
                <input type="button" id="call-button" class="button-${call.id}" value="PRZYJMIJ">
            </div>
            `
    
            $('.conteiner').append(string)
    
            $(`.button-${call.id}`).on('click', function(){
                $.post(`https://${GetParentResourceName()}/getCall`, JSON.stringify({coords: call.coords, id: call.id, source: call.source}));
                console.log(JSON.stringify(call.id))
            });
        }

    }
});