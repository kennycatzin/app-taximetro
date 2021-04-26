
$(window).scroll(function() {
    if ($(this).scrollTop() > 300) {
        $('#up').fadeIn();
    } else {
        $('#up').fadeOut();
    }
});
$('#up').click(function() {        
    $('body,html').animate({ scrollTop: 0 }, 800);
    return false;
});
$(document).ready(async function() {
     await $.post("./services/servicios_empresas.php",{"getMunicipios":""},function(data){
         data = JSON.parse(data);
         if(data["ok"] == true){
            for (var i = 0; i < data["data"].length; i++) {
                $('#municipio').append('<option value="' + data["data"][i].id_municipio + '">' + data["data"][i].municipio + '</option>');
            }
         }else{
             alert('Ha ocurrido un problema');
         }
     });
    await $.post("./services/servicios_empresas.php",{"getGiros":""}, function(miData){
            data2 = JSON.parse(miData);
            if(data2["ok"] == true){
                for (var i = 0; i < data2["data"].length; i++) {
                    $('#giro_turistico').append($('<option></option>').val(data2["data"][i]).text(data2["data"][i])); 

                    // $('#giro_turistico').append('<option value="' + data2["data"][i] + '">' + data2["data"][i] + '</option>');
                }
            }else{
                alert('Ha ocurrido un problema');
            }
    });
    await $.post("./services/servicios_empresas.php",{"getConsultores":""}, function(miData){
        data2 = JSON.parse(miData);
        if(data2["ok"] == true){
            console.log(data2);
            for (var i = 0; i < data2["data"].length; i++) {
                $('#consultor').append($('<option></option>').val(data2["data"][i].id_consultor).text(data2["data"][i].empresa_consultora)); 

                // $('#giro_turistico').append('<option value="' + data2["data"][i] + '">' + data2["data"][i] + '</option>');
            }
        }else{
            alert('Ha ocurrido un problema');
        }
    });
        $('#correcto').hide(); 
        $('#incorrecto').hide(); 


    $("input:radio[name ='rnt']").change(function(){
        if($(this).val() == 1){
            $( "#folio_rnt" ).prop( "disabled", false );
        }else{
            $( "#folio_rnt" ).prop( "disabled", true );
        }
    });
    $( "#municipio" ).change(function() {
        console.log($( "#municipio" ).val());
        var id_municipio = $( "#municipio" ).val();
        $('#localidad option').remove();
        $.post("./services/servicios_empresas.php",{"getLocalidades":"", id_municipio}, function(miData){
            data2 = JSON.parse(miData);
            if(data2["ok"] == true){
                $('#localidad').append($('<option></option>').val("").text("Seleccione la localidad"));
                for (var i = 0; i < data2["data"].length; i++) {
                    $('#localidad').append($('<option></option>').val(data2["data"][i].id_localidad).text(data2["data"][i].localidad)); 
                    // $('#giro_turistico').append('<option value="' + data2["data"][i] + '">' + data2["data"][i] + '</option>');
                }
            }else{
                alert('Ha ocurrido un problema');
            }
    });
    });
    // $("#email").keyup(function() {
    //     if($(this).val().indexOf('@', 0) == -1 || $(this).val().indexOf('.', 0) == -1) {
    //         $("#email").removeClass("is-valid").addClass( "is-invalid" );
    //     }else{
    //         $("#email").removeClass("is-invalid").addClass( "is-valid" );
    //     }
    // });
    // $("#rfc").keyup(function() {
    //     if($(this).val().length != 13) {
    //         $("#rfc").removeClass("is-valid").addClass( "is-invalid" );
    //     }else{
    //         $("#rfc").removeClass("is-invalid").addClass( "is-valid" );
    //     }
    // });
    // $("#apellido_paterno").keyup(function() {
    //     if($(this).val().length <= 2) {
    //         $("#apellido_paterno").removeClass("is-valid").addClass( "is-invalid" );
    //     }else{
    //         $("#apellido_paterno").removeClass("is-invalid").addClass( "is-valid" );
    //     }
    // });
    // $("#nombre_participante").keyup(function() {
    //     if($(this).val().length <= 2) {
    //         $("#nombre_participante").removeClass("is-valid").addClass( "is-invalid" );
    //     }else{
    //         $("#nombre_participante").removeClass("is-invalid").addClass( "is-valid" );
    //     }
    // });
    // $("#telefono").keyup(function() {
    //     if($(this).val().length != 10) {
    //         $("#telefono").removeClass("is-valid").addClass( "is-invalid" );
    //     }else{
    //         $("#telefono").removeClass("is-invalid").addClass( "is-valid" );
    //     }
    // });
    // $("#nombre_comercial").keyup(function() {
    //     if($(this).val().length <= 5) {
    //         $("#nombre_comercial").removeClass("is-valid").addClass( "is-invalid" );
    //     }else{
    //         $("#nombre_comercial").removeClass("is-invalid").addClass( "is-valid" );
    //     }
    // });

    // $("#nombre_comercial").keyup(function() {
    //     if($(this).val().indexOf('@', 0) == -1 || $(this).val().indexOf('.', 0) == -1) {
    //         $("#email").removeClass("is-valid").addClass( "is-invalid" );
    //     }else{
    //         $("#email").removeClass("is-invalid").addClass( "is-valid" );
    //     }
    // });

});

$( "#registra" ).on( "click", function() {
    var tipo_registro = $("input:radio[name ='tipo_registro']:checked").val();
    var rnt = $("input:radio[name ='rnt']:checked").val();
    var alta_inventur = $("input:radio[name ='alta_inventur']:checked").val();
    var experiencia = $("input:radio[name ='experiencia_calidad_higiene']:checked").val();
    // if($('#nombre_participante').val().length <= 2){
    //     $("#nombre_participante").removeClass("is-valid").addClass( "is-invalid" );
    //     return false;
    // }else{
    //     $("#nombre_participante").removeClass("is-invalid").addClass( "is-valid" );
    // }

    // if($('#apellido_paterno').val().length <= 2){
    //     $("#apellido_paterno").removeClass("is-valid").addClass( "is-invalid" );
    //     return false;
    // }else{
    //     $("#apellido_paterno").removeClass("is-invalid").addClass( "is-valid" );
    // }

    // if($('#nombre_comercial').val().length <= 2){
    //     $("#nombre_comercial").removeClass("is-valid").addClass( "is-invalid" );
    //     return false;
    // }else{
    //     $("#nombre_comercial").removeClass("is-invalid").addClass( "is-valid" );
    // }

    // if($('#rfc').val().length != 13){
    //     $("#rfc").removeClass("is-valid").addClass( "is-invalid" );
    //     return false;
    // }else{
    //     $("#rfc").removeClass("is-invalid").addClass( "is-valid" );
    // }

    // if($('#telefono').val().length != 10){
    //     $("#telefono").removeClass("is-valid").addClass( "is-invalid" );
    //     return false;
    // }else{
    //     $("#telefono").removeClass("is-invalid").addClass( "is-valid" );
    // }

    // if($('#email').val().indexOf('@', 0) == -1 || $("#email").val().indexOf('.', 0) == -1){
    //     $("#email").removeClass("is-valid").addClass( "is-invalid" );
    //     return false;
    // }else{
    //     $("#email").removeClass("is-invalid").addClass( "is-valid" );
    // }

    var datos = {
        "nombre_comercial": $('#nombre_comercial').val(), 
        "direccion":  $('#direccion').val(),
        "razon_social":  $('#razon_social').val(),
        "rfc":  $('#rfc').val(),
        "telefono":  $('#telefono').val(),
        "nombre_participante":  $('#nombre_participante').val(),
        "apellido_paterno":  $('#apellido_paterno').val(),
        "apellido_materno":  $('#apellido_materno').val(),
        "email":  $('#email').val(),
        "experiencia_calidad_higiene":  parseInt(experiencia),
        "tipo_registro":  parseInt(tipo_registro),
        "rnt":  parseInt(rnt),
        "folio_rnt":  $('#folio_rnt').val(),
        "alta_inventur":  parseInt(alta_inventur),
        "giro_turistico":  $('#giro_turistico').val(),
        "id_consultor": $('#consultor').val(),
        "id_localidad": $('#localidad').val()
    };
    $.post("./services/servicios_empresas.php", {"altaEmpresa":"", datos},function(data){
        data = JSON.parse(data);
         if(data["ok"] == true){
            document.location.href = './correcto.php';
         }else{
            $('#incorrecto').show(); 
         }
     });
});
$('.style-select').each(function() {
    var div = $(this);
    div.addClass('dropdown');
    var sel = div.find('select');
    div.prepend('<div class="dropdown-menu"></div>');
    div.prepend('<button type="button" class="btn dropdown-toggle form-control" data-toggle="dropdown"><span class="option"></span></button>');
    if (div.hasClass('btn-lg')) {
        div.removeClass('btn-lg');
        div.find('.dropdown-toggle').addClass('btn-lg');
    }
    var span = div.find('.option');
    var menu = div.find('.dropdown-menu');
    sel.find('option').each(function() {
        var a = $('<a href="#">'+$(this).text()+'</a>');
        if (this.hidden) a.addClass('d-none');
        if (this.selected) {
            a.addClass('selected');
            span.text($(this).text());
            var v = this.value;
            if (v!='') div.addClass('selected');
        }
        menu.append(a);
    });
});
$(document).on('click', '.style-select a', function(e) {
    e.preventDefault();
    var a = $(this);
    var i = a.index();
    var sel = a.closest('.style-select').find('select');
    var menu = a.closest('.style-select').find('.dropdown-menu');
    var span = a.closest('.style-select').find('.option');
    span.text(a.text());
    var o = sel.find('option')[i];
    o.selected = true;
    var v = o.value;
    if (v=='') a.closest('.style-select').removeClass('selected');
    else a.closest('.style-select').addClass('selected');
    menu.find('a').removeClass('selected');
    a.addClass('selected');
    sel.change();
});
$('.style-file').each(function() {
    var f = $(this).find(':file');
    var p = f.attr('placeholder') || '';
    $(this).addClass('input-group');
    f.before('<input type="text" class="form-control" placeholder="'+p+'" readonly>').after('<div class="input-group-append"></div>');
    $(this).find('.input-group-append').append('<button class="btn btn-primary" type="button">Elegir</button>');
});
$(document).on('click', '.style-file .btn, .style-file .form-control', function() {
    $(this).parents('.style-file').find(':file').click();
});
$(document).on('change', '.style-file :file', function() {
    var input = $(this);
    var label = input.val().replace(/\\/g, '/').replace(/.*\//, '');
    input.parent('.style-file').find(':text').val(label);
    if (label=='') input.parent('.style-file').removeClass('selected');
    else input.parent('.style-file').addClass('selected');
});
$('.tabs .nav-item').click(function(e) {
    e.preventDefault();
    if (!$(this).hasClass('active')) {
        var t = $(this).attr('href');
        var p = $(this).parents('.tabs');
        p.find('.nav-item').removeClass('active');
        $(this).addClass('active');
        p.find('.card-header').addClass('collapsed');
        p.find('.card-header').filter('[data-target="'+t+'"]').removeClass('collapsed');
        $(t).collapse('toggle');
    }
});
$('.tabs .card-header').click(function(e) {
    e.preventDefault();
    if ($(this).hasClass('collapsed')) {
        var t = $(this).attr('data-target');
        var p = $(this).parents('.tabs');
        p.find('.nav-item').removeClass('active');
        p.find('.nav-item').filter('[href="'+t+'"]').addClass('active');
        p.find('.card-header').addClass('collapsed');
        $(this).removeClass('collapsed');
        $(t).collapse('toggle');
    }
});
$().fancybox({
    selector: '.iframe',
    toolbar: false,
    smallBtn: true,
    type: 'iframe',
    iframe: {
        css: {
            width: '100%',
            maxWidth: '100%',
            maxHeight: '100%',
            margin: 0
        }
    }
});
$().fancybox({
    selector: '.image',
    toolbar: false,
    smallBtn: true,
    type: 'image'
});
$('.inline').fancybox({
    type: 'inline'
});
$.fancyAlert = function(opts) {
    opts = $.extend(
        true,
        {
            message: '',
            type: 'info'
        },
        opts || {}
    );
    var color = (opts.type=='error') ? 'danger' : opts.type;
    $.fancybox.open({
        type: 'html',
        src:
            '<div class="fancy-' + opts.type + ' text-center p-5">' +
            '<div class="d-flex justify-content-center align-items-center">' +
            '<i class="ico ico40 ico-' + opts.type + ' text-' + color + '"></i>' +
            '<div class="h5 mb-0 px-2 w-auto">' + opts.message + '</div>' +
            '</div>' +
            '</div>',
    });
};
$.fancyConfirm = function(opts) {
    opts = $.extend(
        true,
        {
            message: '',
            okButton: 'Aceptar',
            noButton: 'Cancelar',
            callback: $.noop
        },
        opts || {}
    );
    $.fancybox.open({
        type: 'html',
        src:
            '<div class="fancy-warning text-center p-3">' +
            '<div class="d-flex justify-content-center align-items-center">' +
            '<i class="ico ico40 ico-warning text-warning"></i>' +
            '<div class="h5 mb-0 px-2 w-auto">' + opts.message + '</div>' +
            '</div>' +
            '<div class="text-center pt-3">' +
            '<button data-value="0" data-fancybox-close class="btn btn-outline-light mx-1">' + opts.noButton + '</button>' +
            '<button data-value="1" data-fancybox-close class="btn btn-warning mx-1">' + opts.okButton + '</button>' +
            '</div>' +
            '</div>',
        opts: {
            modal: true,
            afterClose: function(instance, current, e) {
                var button = e ? e.target || e.currentTarget : null;
                var value = button ? $(button).data("value") : 0;
                opts.callback(value);
            }
        }
    });
};
$.fancyPrompt = function(opts) {
    opts = $.extend(
        true,
        {
            message: '',
            okButton: 'Aceptar',
            noButton: 'Cancelar',
            callback: $.noop
        },
        opts || {}
    );
    $.fancybox.open({
        type: 'html',
        src:
            '<div class="fancy-primary text-center p-3">' +
            '<div class="d-flex justify-content-center align-items-center">' +
            '<i class="ico ico40 ico-help text-primary"></i>' +
            '<div class="h5 mb-0 px-2 w-auto">' + opts.message + '</div>' +
            '</div>' +
            '<div class="text-center pt-3">' +
            '<input type="text" class="form-control" id="fancy-prompt">' +
            '</div>' +
            '<div class="text-center pt-3">' +
            '<button data-value="1" data-fancybox-close class="btn btn-outline-primary mx-1">' + opts.okButton + '</button>' +
            '<button data-value="0" data-fancybox-close class="btn btn-outline-secondary mx-1">' + opts.noButton + '</button>' +
            '</div>' +
            '</div>',
        opts: {
            modal: true,
            afterShow : function(instance, current) {
                $(document).find('#fancy-prompt').focus();
            },
            beforeClose: function(instance, current, e) {
                var resp = $(document).find('#fancy-prompt').val();
                var button = e ? e.target || e.currentTarget : null;
                var value = button ? $(button).data("value") : 0;
                if (resp=='' && value) {
                    $(document).find('#fancy-prompt').focus();
                    return false;
                }
                else opts.callback(value, resp);
            }
        }
    });
};

$.validator.setDefaults({
    ignore: [],
    errorElement: "div",
    errorPlacement: function (error, element) {
        error.addClass("invalid-feedback");
        if (element.prop("type") === "radio") {
            error.insertAfter(element.parents(".custom-radio"));
        }
        else if (element.prop("type") === "checkbox") {
            error.insertAfter(element.parents(".custom-checkbox"));
        }  else {
            error.insertAfter(element);
        }
    },
    highlight: function (element, errorClass, validClass) {
        $(element).closest('.form-group').find('.form-control').addClass("is-invalid").removeClass("is-valid");
    },
    unhighlight: function (element, errorClass, validClass) {
        $(element).closest('.form-group').find('.form-control').addClass("is-valid").removeClass("is-invalid");
    },
    submitHandler: function(form) {
        form.submit();
    }
});
$(".letras").keypress(function (key) {
    if ((key.charCode < 97 || key.charCode > 122)//letras mayusculas
        && (key.charCode < 65 || key.charCode > 90) //letras minusculas
        && (key.charCode != 45) //retroceso
        && (key.charCode != 241) //ñ
         && (key.charCode != 209) //Ñ
         && (key.charCode != 32) //espacio
         && (key.charCode != 225) //á
         && (key.charCode != 233) //é
         && (key.charCode != 237) //í
         && (key.charCode != 243) //ó
         && (key.charCode != 250) //ú
         && (key.charCode != 193) //Á
         && (key.charCode != 201) //É
         && (key.charCode != 205) //Í
         && (key.charCode != 211) //Ó
         && (key.charCode != 218) //Ú
        )
        return false;
});
$(".letNum").keypress(function (key) {
    if ((key.charCode < 97 || key.charCode > 122)//letras mayusculas
        && (key.charCode < 65 || key.charCode > 90) //letras minusculas
        && (key.charCode != 45) //retroceso
        && (key.charCode != 241) //ñ
         && (key.charCode != 209) //Ñ
         && (key.charCode != 32) //espacio
         && (key.charCode != 225) //á
         && (key.charCode != 233) //é
         && (key.charCode != 237) //í
         && (key.charCode != 243) //ó
         && (key.charCode != 250) //ú
         && (key.charCode != 193) //Á
         && (key.charCode != 201) //É
         && (key.charCode != 205) //Í
         && (key.charCode != 211) //Ó
         && (key.charCode != 218) //Ú
         && (key.charCode != 49) //1
         && (key.charCode != 50) //2
         && (key.charCode != 51) //3
         && (key.charCode != 52) //4
         && (key.charCode != 53) //5
         && (key.charCode != 54) //6
         && (key.charCode != 55) //7
         && (key.charCode != 56) //8
         && (key.charCode != 57) //9
         && (key.charCode != 48) //0
        )
        return false;
});
$(".numeros").keypress(function (key) {
    if($("#telefono").val().length >= 10){
        return false;
    }
    if ((key.charCode != 49) //1
         && (key.charCode != 50) //2
         && (key.charCode != 51) //3
         && (key.charCode != 52) //4
         && (key.charCode != 53) //5
         && (key.charCode != 54) //6
         && (key.charCode != 55) //7
         && (key.charCode != 56) //8
         && (key.charCode != 57) //9
         && (key.charCode != 48) //0

        )
        return false;
});
var validator = $("#registro").validate({
    rules: {
        nombre_comercial: {
            required: true,
        },
        razon_social: {
            required: true
        },
        direccion: {
            required: true
        },
        rfc: {
            required: true,
            rfc: true
        },
        telefono: {
            required: true,
            digits: true,
            minlength: 10,
            maxlength: 10
        },
        nombre_participante: {
            required: true
        },
        apellido_paterno: {
            required: true
        },
        email: {
            required: true,
            email: true
        },
        rnt: {
            required: true,
        },
        tipo_registro: {
            required: true,
        },
        alta_inventur: {
            required: true,
        },
        experiencia_calidad_higiene: {
            required: true,
        },
        municipio: {
            required: true,
        },
        giro_turistico: {
            required: true,
        },
        localidad: {
            required: true,
        },
        consultor: {
            required: true,
        },
        protesta: {
            required: true
        },
        privacidad: {
            required: true
        }
    },
    messages: {
        nombre_comercial: {
            required: "Ingresa tu nombre comercial"
        },
        razon_social: {
            required: "Ingresa la razón social"
        },
        rfc: {
            required: "Ingresa la RFC",
            rfc: "El formato RFC no es válido" 
        },
        telefono: {
            required: "Ingresa el teléfono",
            digits: "Solo se aceptan dígitos"
        },
        nombre_participante: {
            required: "Ingresa el nombre del participante"
        },
        apellido_paterno: {
            required: "Ingresa el apellido paterno"
        },
        email:{
            required: "Ingresa tu correo electrónico",
            email: "El formato no es válido"
        },
        protesta: {
            required: "Este campo es requerido"
        },
        privacidad: {
            required: "Este campo es requerido"
        }
    }
});