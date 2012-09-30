makeTimeline = (d,i) ->
	timelineoptions = {
		type:       'timeline'
		width:      '100%'
		height:     '620'
		source:     d.url
		embed_id:   'timeline'+i
	}
	$(document).ready(->
	    createStoryJS(timelineoptions)
	)
		
makeBuilder = (sections) ->
    builder = d3.select("#section-summary ol")
    
    sectionli = builder.selectAll('.section-summary-item')
    .data(sections)
    .enter().append("li")
        .attr("class", "section-summary-item")
#        .text((d,i) -> i)
            
    summaryheader = sectionli.append("div").attr("class", "summary-header")        
    summaryheader.append("h4").text((d,i) -> 
        if d.title isnt undefined
            d.title
        else
            "> No title given."
    )    
    summaryheader.append("div").attr("class", "sectiontype").text((d,i) -> d.type)
       
    summarycontent = sectionli.append("div").attr("class", "summary-content")
    summarycontent.append("div").attr("class", "image-url").text((d,i) -> d.url)        
#    summarycontent.append("div").attr("class", "sectiontext").text((d,i) -> d.caption)

correctInputs = ->
    switch $('#type').val() 
        when "image"
            $('#embed-wrapper').hide()        
            $('#caption').hide()
            $('#url-wrapper').show();
        when "image2"
            $('#embed-wrapper').hide()        
            $('#caption').show()
            $('#url-wrapper').show()
            $('#caption').attr("rows", 2)
        when "image3"
            $('#embed-wrapper').hide()        
            $('#caption').show()
            $('#url-wrapper').show();
            $('#caption').attr("rows", 5)
        when "vimeo"
            $('#embed-wrapper').hide()
            $('#caption').show()
            $('#url-wrapper').show();            
        when "soundcloud"
            $('#embed-wrapper').show()        
            $('#caption').hide()
            $('#url-wrapper').hide();
        when "timeline"
            $('#embed-wrapper').hide()        
            $('#caption').hide()
            $('#url-wrapper').show();                        
            
getJsonCode = ->
    $('#json-code').val(sections.join("")).show()
    
submitNewSection = ->
    console.log "Submitttt"
    sectionTitle = $("#add-section #title").val();
    sectionUrl = $("#add-section #url").val();
    sectionCaption = $("#add-section #caption").val();    
    sectionType = $("#add-section #type").val();
    sectionEmbed = $("#add-section #embed").val();
    
    if sectionType is "image" or sectionType is "image2" or sectionType is "image3"
        sections.push({
            title: sectionTitle
            type: sectionType
            url: sectionUrl
            caption: sectionCaption
            })
    else if sectionType is "vimeo"
        sections.push({
            title: sectionTitle
            type: sectionType
            url: sectionUrl
            caption: sectionCaption
        })
    else if sectionType is "soundcloud"
        sections.push({
            title: sectionTitle
            type: sectionType
            embed: sectionEmbed
        })

    $("#container").html("");
    $("#section-summary ol").html("");
    sStory(sections)
    makeBuilder(sections)

            
sStory = (sections) ->    

    makeBuilder(sections)
    container = d3.select("#container")
    container.selectAll('.section')
    .data(sections)
    .enter().append("div")
        .attr("class", (d,i) ->
	 			return "section "+d.type+" "+d.type+i
				)
        .html((d,i) ->
            switch d.type
                when "image"
                    console.log "image"
                    html = ich.image(d, true)
                when "image2"
                    console.log "image2"
                    html = ich.image2(d, true)
                when "image3"
                    console.log "image3"
                    html = ich.image3(d, true)
                when "vimeo"
                    console.log "vimeo"				
                    html = ich.vimeo(d, true)										
                when "soundcloud"
                    console.log "soundcloud"
                    html = ich.soundcloud(d, true)                    
                when "map"
                    console.log "map"
                when "timeline"
                    html = "<h2>"+d.title+"</h2> "
                    html += "<div id='timeline"+i+"'></div>"
                    makeTimeline(d,i)
                    console.log "timeline"
              
            return html
        )
				.style("background-image", (d,i) ->
				    if d.type is "image" or d.type is "image2" or d.type is "image3"
					    return "url('"+d.url+"')"
				)