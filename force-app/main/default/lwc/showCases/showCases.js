import { LightningElement,wire } from 'lwc';
import GetCases from '@salesforce/apex/getAccountrecordforLWC.GetCases'
export default class ShowCases extends LightningElement {
@wire(GetCases) allCases;
}