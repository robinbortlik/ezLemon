// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
$(document).ready(function() {
    $('.flash-message').bind('click', function() {
        $(this).remove();
    })
    initFormStyles();
});


$(document).ready(function() {
    $(document).bind("ajaxSend", function(){
        insertAjaxIndicator();
        $('#ajax-indicator').show();
    }).bind("ajaxComplete", function(){
        $.uniform.update("input:text, textarea, select");
        $("a.new-item-link, input:submit" ).button();
        $('#ajax-indicator').hide();
        removeAjaxIndicator();
    });
});

function initFormStyles(){
    $("input:text, textarea, select").uniform();
    $("a.new-item-link, input:submit" ).button();
}


function insertAjaxIndicator(){
    removeAjaxIndicator();
    $('body').append(
        "<div id=\"ajax-indicator\" style=\"display: none;\">\n\
<img src=\"/images/ajax-loader.gif\" alt=\"Ajax-loader\"> \n\
</div>"
        )
}

function removeAjaxIndicator(){
    $('#ajax-indicator').remove();
}


function initFillGaps(){
    $('.draggable-word').draggable({
        revert: true
    });

    $(".blank-word").droppable({
        accept: ".draggable-word",
        activeClass: 'droppable-active',
        hoverClass: 'droppable-hover',
        drop: function(ev, ui) {
            $(this).replaceWith($(ui.draggable).text());
            $('textarea#excercises_result_result').val($('div#result-container').html());
            ui.draggable.remove();
            return true;
        }
    })
}

function reloadExcercise(){
    $('textarea#excercises_result_result').val('');
    $("form.edit_excercises_result").submit();
}

function updateExcercisePreview(url){
    $(".update-on-change").bind("change", function(){
        $.ajax({
            type: "post",
            url: url,
            data: "excercise[language_id]=" + $('#excercise_language_id').val()+"&" + "excercise[excercise_type]=" + $('#excercise_excercise_type').val()
        })
    })
}

function languageSelectButtons(el_id){
    $( "#" + el_id).buttonset();

    $( "#"+el_id +" > input").click(function(){
      $.ajax({
          url: $(this).attr("data-url"),
          type: $(this).attr("data-method")
        })
      }
);

}