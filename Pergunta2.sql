CREATE OR REPLACE FUCTION cat_r1_proc()
    RETURNS TRIGGER AS
    $$
    BEGIN
        IF NEW.category_name = NEW.super_category_name
            THEN RAISE EXCEPTION 'Cannot insert a category into itself';
        END IF;
        RETURN NEW;
    END;
    $$ language plpgsql;

CREATE TRIGGER cat_r1 
    BEFORE INSERT 
    ON TABLE has_other
    FOR EACH ROW
    EXECUTE PROCEDURE cat_r1_proc();
