CREATE TABLE IF NOT EXISTS dataclient (
  guid character varying(255) COLLATE pg_catalog."default" NOT NULL,
  primary_region integer NOT NULL,
  failover_region integer NOT NULL,
  http_code integer,
  insertedon time without time zone
);

CREATE TABLE IF NOT EXISTS failoverevents (
  event integer NOT NULL,
  insertedon timestamp without time zone NOT NULL
);
