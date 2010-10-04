/***************************************************************************************************************************
 * If you are going to rip this off, please credit me                                                                       *
 *                                                                                                                          *
 *	Author Tim Wilkinson                                                                                               *
 *	www site http://www.twsoft.co.uk                                                                                   *
 *	mail tjw@twsoft.co.uk                                                                                              *
 *                                                                                                                          *
 *       This is version 1.1 of my bb2xml convertor, it was designed to run on a linux box so apologies if it don't         *
 *       run on your particular box. Again it was written to fit a particular need where I wanted to export service changes *
 *       and latest state of all services monitored by BB to a third party application                                      *                                                                                       *
 ****************************************************************************************************************************
 */

#include <stdlib.h>
#include <string.h>
#include <time.h>
#include <stdio.h>
#include <dirent.h>
#include <sys/types.h>



char colours[5][7] = {"red","green","yellow","purple","clear"};

struct querylist {
	char *queryname;
	char *queryvalue;
	struct querylist * next;
};

struct servicelist {
	char  *servicename;
	char  *status;
	time_t duration;
	struct servicelist * next;
	
};

struct alertinfo {
	char * servername;
	char * service;
	time_t starttime;
	int from;
	int to;
	struct alertinfo *next;
	struct alertinfo *previous;
};
struct serverinfo {
	char *servername;
	struct servicelist *services;
	struct serverinfo *next;
	struct serverinfo *previous;
};


void writeserverlist(struct alertinfo **, struct serverinfo **, char *, unsigned long);
void insertalert(struct alertinfo **, struct alertinfo *);

void parsequery( char *, struct querylist **);
char * getparam(char *, struct querylist **);
time_t process_content( FILE *, char ** , char *, char * , struct  alertinfo **, unsigned long);


char * getparam( char * param ,struct querylist **queries){
	struct querylist *previous;
	char * dummy;
	if (*queries != NULL)
	{
		previous = *queries;
		do {
			if ((char *) strcmp(previous->queryname, param) == NULL)
				return(previous->queryvalue);
			previous = previous->next;
		} while (previous != NULL);
		
		
	}	
	return (NULL);
}
void insertalert(struct alertinfo **alertlist, struct alertinfo *newalert){
	struct alertinfo *next, *previous;
	int i=0;
	
	//use I to indicate states; 0=head, 1=mid, 2= end
	if (*alertlist == NULL){
		*alertlist = newalert;
		return;
	}
	else{
		//walk through the list
		previous = *alertlist;
		i=0;
		while (previous->starttime < newalert->starttime)
		{
			if (previous->next == NULL)
			{	
				i=2;
				break;
			}
			else{
				i=1;
				previous = previous->next;
			}
			
		}
		
		switch (i)
		{ 
			case 0:
			{
				
				//insert at the head of the list
				*alertlist = newalert;
				newalert->next = previous;
				previous->previous = newalert;
				break;
			}
			case 1:
			{
				
				//insert mid list
				next =previous;
				previous = next->previous;
				newalert->next = next;
				newalert->previous = previous;
				previous->next = newalert;
				next->previous = newalert;
				break;
			}
			case 2:
			{
				
				//insert at the end of the list
				newalert->previous = previous;
				previous->next = newalert;
				break;
			}
		}
		
	}
}


int colour2index(char *colour){
	int i;
	for (i= 0; i <5; i++) {
		if (strcmp(colours[i],colour) == 0){
			return (i);
		}
	}
	return (-1);
}

void parsequery( char * data, struct querylist **queries)
{
	char *token, *next, *pair;
	struct querylist *query, *previous;
	pair = data;
	while ( pair != NULL){
		next = strchr(pair,'&');
		if ( next != NULL)
		{
			*next = '\0';
			next++;
		}
		token = strchr(pair,'=');
		query = (struct querylist*) malloc(sizeof (struct querylist));
		if (token != NULL) {
			*token = '\0';
			token++;
		}
		query->queryname = strdup(pair);
		if (token != NULL)
			query->queryvalue = strdup(token);
		else
			query->queryvalue = NULL;
		query->next = NULL;
		
		if (*queries == NULL)
			*queries = query;
		else
		{
			previous = *queries;
			while (previous->next != NULL)
				previous = previous->next;
			previous->next = query;
		}
		pair = next;
	}	
	
}

main(int argc, char *argv[]){
	
	DIR *dirp;
	struct   dirent *namelist;
	
 	int n;
	char *service, *p;
	char *sourcedir = "/Users/twexler/tmp";
	char buffer[255];
	struct serverinfo *serverlist = NULL;
	struct alertinfo *alertlist = NULL;
	struct querylist *queries = NULL;
	char * colour,  *data, *servername ;
	time_t start,duration,now;
	
	unsigned long alert=3600;
	
	FILE *fp;
	data = getenv("QUERY_STRING");
	
	
	if ( data != NULL)
	{
		
		parsequery(data, &queries);
		service = getparam("dir", &queries);
		if (service != NULL){
			sourcedir=service;
			
		}
		service = getparam("alertPeriod", &queries);
		if (service != NULL)
			alert = strtoul(service,NULL,10);
	}
	if (alert == 0)
		alert = 3600;
	
	
	dirp = opendir(sourcedir);
	
	while (dirp) {
		if ((namelist = readdir(dirp)) != NULL) { 
			/*ok rules for bb state files.	
			 1) there must be a single .  to seperate the service from the hostname
			 2) all other dns zones etc are defined by ,
			 
			 */
			
			//don't want files that start with .			
			if (namelist->d_name[0] == '.')
				continue;
			//or ones with more than one .
			p = strchr(namelist->d_name,'.');
			//but we do want at least one
			if ( p == NULL)
				continue;
			p++;
			if (strchr(p,'.') != NULL)
				continue;
			
			
			
			
			service = strchr(namelist->d_name,'.');
			sprintf(buffer,"%s/%s",sourcedir, namelist->d_name);
			
			
			
			if (service == '\0')
				continue;
			
			*service++ =0;
			
			p = namelist->d_name;	
			while (*p != '\0')
			{
				if (*p == ',')
					*p = '.';
				p++;
			}
			p = namelist->d_name;
			
			
			
			if((fp =fopen(buffer,"r")) == NULL)
			{
				fprintf(stderr, "%s: Can't open %s\n", argv[0], buffer);
				exit (1);
			}
  			
			start = process_content (fp, &colour,p, service, &alertlist, alert);
			now = time(NULL);
			duration = now - start;
			fclose(fp);
			add_to_list(&serverlist,p, service,colour,duration);	
			
		}
		else
		{
			closedir(dirp);
			break;
		}
		
  	}
  	/*if (dirp) {
		closedir(dirp);
	}*/
  	 
  	
	
	writeserverlist(&alertlist, &serverlist, sourcedir, alert);
	
	
}
time_t  process_content( FILE *fp, char **status, char *servername, char *service, struct alertinfo **alertlist, unsigned long alertPeriod )
{
	char buffer[512];
	int i,monthindex, currentmonth=-1;
	unsigned long  red[13], green[13];
	unsigned long start;
	char startmonth[4], thismonth[4], day[4], month[4], timeofday[10],colour[10],laststate[10];
	time_t starttime, duration;
	int      dayofmonth, year;
	struct alertinfo *newalert, *lastalert, *dummy;
	time_t now;
	now = time(NULL);
	now = now - alertPeriod;
	
	while (!feof(fp))
	{
		if(fgets(buffer, 512, fp) != NULL)
		{
			strcpy(laststate,colour);
			duration = 0;
			if (sscanf(buffer, "%s %s %d %s %d %s   %d %d",day, month, &dayofmonth,timeofday, &year, colour, &starttime, &duration) != 8){
				//printf("%s %s %d %s %d %s   %d\n----------------------------------------------------------------------\n ",day, month, dayofmonth,timeofday, year, colour, starttime); 
			}
			
			if (starttime > now)
			{
				
				newalert = (struct alertinfo*) malloc(sizeof (struct alertinfo));
				newalert->servername = strdup(servername);
				newalert->service = strdup(service);
				newalert->next = NULL;
				newalert->previous = NULL;
				newalert->starttime = starttime;
				newalert->from = colour2index(laststate);
				newalert->to = colour2index(colour);
				
				insertalert(alertlist,newalert);
				
			}
			
			
			
		}
	}
	*status = strdup(colour);
	
	return (starttime);
}

add_to_list(struct serverinfo **serverlist,char *servername, char *service, char *status, time_t duration)
{
	int found=0;
	struct serverinfo *current,*newserver;
	struct servicelist *currentservice,*newservice;
	//try to find the name in the list
	
	if (*serverlist != NULL) {
		current = *serverlist;
		while (! found){
			if ( strcmp(current->servername, servername) != 0)
			{
				if (current->next != NULL)
					current = current->next;
				else
					break;
				
			}
			else
			{
				found =1;
				break;
			}
		}
	}
	if (!found)
		
		// we need to create an server entry
		
	{
		newserver = (struct serverinfo*) malloc(sizeof (struct serverinfo));
		newserver->servername = strdup(servername);
		newserver->next = NULL;
		newserver->previous = NULL;
		newserver->services = NULL;
		if (*serverlist == NULL)
			*serverlist = newserver;
		else
		{
			current->next = newserver;
			newserver->previous = current;
		}
		current = newserver;
		
	}
	//now we need to create a service entry for the server in current
	
	//create a service
	newservice = (struct servicelist*) malloc(sizeof (struct servicelist));
	newservice->servicename = strdup(service);
	newservice->status = status;
	newservice->duration = duration;
	newservice->next = NULL;
	
	
	if (current->services != NULL)
	{
		//find the end of the chain
		currentservice = current->services;	
		while ( currentservice->next != NULL)
		{
			currentservice = currentservice->next;
		}
		currentservice->next = newservice;
	}
	else
		current->services = newservice;
}
void writeserverlist( struct alertinfo **alertlist , struct serverinfo **serverlist, char *dir, unsigned long alert)
{
	struct serverinfo *current;
	
	struct servicelist *currentservice;
	struct alertinfo *thisalert;
	char *from, *to;
	printf("Content-Type: text/html\n\n<?xml version=\"1.0\" ?>\n\n");
	printf("<bbdata>\n");
	printf("\t<version>\n\t\t1.0\n\t</version>\n");
	printf("\t<useage>\n\t\tAs cgi :- bb2xml?dir='source of bbhistory file'&#x26;alertPeriod='Time in seconds'\n\t</useage>\n");
	printf("\t<defaults>\n\t\tdir='/home/bb/bbvar/hist'\n\t\talertPeriod=3600\n\t</defaults>\n");
	printf("\t<bb_source>\n\t\t%s\n\t</bb_source>\n",dir);
	printf("\t<alert_duration>\n\t\t%d\n\t</alert_duration>\n",alert);
	
	if (*alertlist != NULL) {
		printf("\t<alerts>\n");
		thisalert = *alertlist;
		while (thisalert != NULL){
			printf("\t\t<alert name=\"%s\">\n",thisalert->servername);
			from = colours[thisalert->from];
			to = colours[thisalert->to];
			printf("\t\t\t<name>%s</name>\n\t\t\t<time>%d</time>\n\t\t\t<from>%s</from>\n\t\t\t<to>%s</to>\n",thisalert->service, thisalert->starttime , from, to);
			thisalert = thisalert->next;
			printf("\t\t</alert>\n");
		}
		printf("\t</alerts>\n");
	}
	
	printf("\t<hosts>\n");
	if (*serverlist != NULL) {
		current = *serverlist;
		while (current != NULL){
			printf("\t\t<server name=\"%s\">\n",current->servername);
			currentservice = current->services;
			while (currentservice != NULL) {
				printf("\t\t\t<service>\n\t\t\t\t<name>%s</name>\n\t\t\t\t<status>%s</status>\n\t\t\t\t<duration>%d</duration>\n\t\t\t</service>\n",currentservice->servicename, currentservice->status, currentservice->duration);
				currentservice = currentservice->next;
			}
			printf("\t\t</server>\n");
			current = current->next;
			
		}
	}
	printf("\t</hosts>\n\r");
	printf("</bbdata>\n");
}
