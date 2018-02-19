package br.gov.pb.util;

import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.PrintStream;
import java.lang.instrument.IllegalClassFormatException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;

import org.apache.poi.openxml4j.exceptions.InvalidFormatException;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;
import org.apache.poi.ss.usermodel.WorkbookFactory;


public class ReadXLS{
  public String getColuna(int aba, int coluna) throws InvalidFormatException, IOException{
    InputStream inputStream = new FileInputStream("C:\\ArquivoSagres\\excel\\servidor.xlsx");
    Workbook workbook = WorkbookFactory.create(inputStream);
    Sheet sheet = workbook.getSheetAt(aba);
    int ultimaLinha = sheet.getLastRowNum();
    String listaCPF = "('";
    for (int i = 5; i < ultimaLinha - 1; i++){
      Row row = sheet.getRow(i);
      Cell cell = row.getCell(coluna);
      listaCPF = listaCPF + cell.getStringCellValue() + "','";
    }
    listaCPF = listaCPF.substring(0, listaCPF.length() - 2) + ")";
    return listaCPF;
  }
  
  public List<String> getColunaLista(int aba, int coluna, int linha, String tipoValor, String arquivo) throws InvalidFormatException, IOException {
    InputStream inputStream = new FileInputStream(arquivo);
    Workbook workbook = WorkbookFactory.create(inputStream);
    Sheet sheet = workbook.getSheetAt(aba);
    int ultimaLinha = sheet.getLastRowNum();
    List<String> lista = new ArrayList();
    for (int i = linha; i < ultimaLinha - 1; i++){
      Row row = sheet.getRow(i);
      Cell cell = row.getCell(coluna);
      if (tipoValor == "string"){
        lista.add(cell.getStringCellValue());
      }else{ 
    	  if (tipoValor == "cpf"){
    		  int numero = (int)cell.getNumericCellValue();
    		  lista.add(new DecimalFormat("00000000000").format(numero));
    	  }else{
    		  if (tipoValor == "vandesc"){
		        int numero = (int)cell.getNumericCellValue();
		//        System.out.println(new DecimalFormat("000").format(numero));
		        lista.add(new DecimalFormat("000").format(numero));
    		  }
    	  }
      }
    }
  return lista;
  }
}
