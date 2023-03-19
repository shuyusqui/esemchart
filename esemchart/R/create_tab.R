#' Create a table in APA style
#'
#'This is a wrapper around "flextable" and "gt" package to create a table.
#'"Digits" in this function is only used when selecting a "flextable" type.
#' @param x an object from the result made by apa.loading.table function.
#' @param latentname a list of the latent variable names.
#' @param itemname a list of the item names made by itemname function.
#' @param title set a title for your table.
#' @param digits a number to keep the decimal number when choosing the "flextable" type.
#' @param model a string which means a kind of analysis,such as "cfa","esem"or "esem within cfa".
#' @param type type of the table format, choices are "flextable" and "gt".
#'
#' @return an HTML table.
#' @export
#'
#' @examples
#' \dontrun{
#' la<-c("f1","f2")
#' item<-list(f1=c("amo1","amo2","amo3"),f2=c("ex1","ex2","ex3"))
#' data2<-read.csv(file="D:/Users/squarrel/rdata/shuju.csv",header=true,sep=",")
#' model1<-'f1=~amo1+amo2+amo3+amo4'
#' fit<-lavaan::cfa(model1,data2)
#' mytable<-apa.loading.table(fit,1)
#' create_tab(mytable,la,item,title="ESEM loading",model="esem",type="flextable")
#' }
create_tab<-function(x,latentname=NULL,itemname=NULL,title=NULL,digits=3,model=NULL,type="flextable"){
  itemname<-itemname%>%as.list
  title=x$table.title
  if(!type%in%c("flextable","gt")){
    rlang::abort(message="please choose a kind of type,choices are flextable and gt")
  }
  if(type=="flextable"){
    if(model=="cfa"){
      load_table1<-x$table.body
      table<-load_table1[,-c(8,9)]%>%data.frame()%>%flextable::flextable()%>%flextable::autofit()%>%
        flextable::set_caption(caption=title)%>%flextable::colformat_double(digits=digits)%>%
        flextable::align_text_col(align="center")%>%flextable::theme_apa()%>%flextable::bold(.,i=1,part='header')
    }
      if(model%in% c("esem within cfa","esem")){
         latentrep<-rep(latentname,times=lengths(itemname))
         nitem<-nrow(x$table.body)
         latentrep<-matrix(latentrep,nitem,1)
         colnames(latentrep)<-c("latent")
         final_ai<-cbind(x$table.body,latentrep)
         load_table<-final_ai
    load_table<-flextable::as_grouped_data(x=final_ai,groups=c("latent"))
    table<-load_table%>%flextable::flextable()%>%flextable::set_caption(caption=title)%>%
    flextable::colformat_double(digits=digits)%>%flextable::align_text_col(align="center")%>%flextable::theme_apa()
    }
  }
  if(type=="gt"){
    if(model=="cfa"){
      load_table<-x$table.body
      load_table<-load_table[,-c(8,9)]
    }
    if(model%in% c("esem within cfa","esem")){
      latentrep<-rep(latentname,times=lengths(itemname))
      nitem<-nrow(x$table.body)
      latentrep<-matrix(latentrep,nitem,1)
      colnames(latentrep)<-c("latent")
      final_ai<-cbind(x$table.body,latentrep)
      load_table<-final_ai
      load_table<-load_table%>%dplyr::group_by(load_table$latent)
    }
  table<-load_table%>%gt::gt()%>%gt::tab_header(title=title)%>%
      gt::tab_style(style=cell_borders(sides='all',color=NULL,weight=NULL),locations=cells_body(columns = everything(),rows=everything()))%>%
      gt::tab_style(style=cell_borders(sides=c('bottom'),color='black',weight=px(2)),locations=cells_title(groups='title'))%>%
      gt::cols_align(align="center",columns = everything())%>%
      gt::tab_style(style=cell_text(font="\u5fae\u8f6f\u96c5\u9ed1"),locations=cells_title(groups='title'))%>%
      gt::tab_style(style=cell_text(font="Times New Roman"),locations=cells_column_labels())%>%
      gt::tab_style(style=cell_text(font="Times New Roman"),locations=cells_body(columns=everything(),rows=everything()))%>%
      gt::cols_width(everything()~px(80))%>%
      gt::tab_style(style=cell_borders(sides=c('top'),color='white',weight=px(2)),locations=cells_title(groups='title'))%>%
      gt::tab_style(style=cell_borders(sides=c('bottom'),color='black',weight=px(1)),locations=cells_column_labels(columns=everything()))%>%
      gt::tab_style(cell_borders(sides=c('bottom'),color='black',weight=px(2)),locations=cells_body(columns=everything(),rows=nrow(load_table)))%>%
      gt::tab_options(table_body.hlines.color = "white",
                  table_body.border.top.width = px(1),
      )}
  return(table)
}
