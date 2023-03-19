#' Generate table for parameter estimates
#'
#' This function can generate a table list for the parameter estimates from 'cfa' function,
#' which can be used to make an APA table in following.
#' @param data an object from the result of lavaan::cfa function.
#' @param par a list of parameters to have in the table.
#' @param table.number a number presenting the order of the table.
#' @param model a string which means a kind of analysis,such as "cfa" or "ESEM within cfa"
#' @param digits a number to keep the decimal number.
#'
#' @return a table_all object.
#' @export
#'
#' @examples
#' \dontrun{
#' data2<-read.csv(file="D:/Users/squarrel/rdata/shuju.csv",header=true,sep=",")
#' model1<-'f1=~amo1+amo2+amo3+amo4'
#' fit<-lavaan::cfa(model1,data2)
#' apa.par.table(fit,c("cfi","tli"),table.number=1,model="cfa",digits=2)
#' }
apa.par.table<-function(data,par,table.number=NA,model="ESEM within cfa",digits=NA){
  table_number<-table.number
  re<-lavaan::fitMeasures(data,par)%>%data.frame()
  n<-length(par)
  para<-re[1:n,]
  para2<-as.numeric(para)%>%round(digits=digits)
  para1<-par
  nl<-length(para2)
  output_para<-matrix(" ",1,nl)
  label=c("method",model)
  for(i in 1:nl){
    output_para[1,i]<-para2[i]
  }

  output_matrix_console<-c(output_para[1,])
  output_matrix_console<-matrix(output_matrix_console,1,nl)
  rownames(output_matrix_console)<-c(label[2])
  colnames(output_matrix_console)<-c(para1)
  table_title<-" goodness-of-fit indices\n"
  table_body<-output_matrix_console
  table_all<-list(table.number=table_number,
                  table.title=table_title,
                  table.body=table_body)
  return(table_all)
}

#' Generate table for the item loadings
#'
#' @param x an object from the result of lavaan::cfa function.
#' @param table.number a number presenting the order of the table.
#' @param model  a string which means a kind of analysis,such as "cfa","ESEM" or "ESEM within cfa"
#'
#' @return a table_all object
#' @export
#'
apa.loading.table<-function(x,table.number=NA,model="cfa"){
  table_number<-table.number
  if(model=="esem_efa"){
    table_body<-esem_load(x)
  }else{
  standload<-lavaan::standardizedsolution(x)
  latent<-standload[standload$op=="=~",]
  cfa.load<-latent%>%dplyr::mutate(CI=ci.col(.))%>%
    dplyr::mutate(p.value=symnum(latent$pvalue,
                                   cutpoints=c(0,0.001,0.01,0.05,1),
                                   symbols = c("***","**","*","")))%>%
    dplyr::select(-one_of('ci.lower','ci.upper'))
  ad<-sprintf("%1.3f",cfa.load$est.std)%>%matrix()
  add.star<-cbind(ad,cfa.load$p.value)
  est<-paste(add.star[,1],add.star[,2],sep="")
  cfa.load1<-dplyr::mutate(cfa.load,est=est,.after="rhs")
  cfa.load<-dplyr::select(cfa.load1,-one_of('est.std'))
  load<-dplyr::arrange(cfa.load,cfa.load[,c(1,3)])
  load1<-tidyr::spread(data=load[,c(1,3,4)],key="lhs",value=est)

  if(model=="cfa"){
    table_body<-cfa.load
  }
  if(model=="esem within cfa"){
    table_body<-load1
  }
}
  table_title<-"standerdized loadings\n"
  table_all<-list(table.number=table_number,
                  table.title=table_title,
                  table.body=table_body)
  return(table_all)
}
